module GraphQL.Engine exposing
    ( batch
    , Selection, select, map, map2, withName
    , Query, query, queryRisky, queryTask, queryRiskyTask
    , Mutation, mutation, mutationRisky, mutationTask, mutationRiskyTask
    , Subscription, subscription
    , Error(..)
    , queryString
    , Argument(..), maybeScalarEncode
    , decodeNullable
    , Request, send, simulate, mapRequest
    , Option(..), InputObject, inputObject, addField, addOptionalField, encodeInputObjectAsJson, inputObjectToFieldList
    , andMap, versionedJsonField, versionedName, versionedAlias
    , bakeToSelection
    )

{-|

@docs batch

@docs Selection, select, with, map, map2, withName

@docs Query, query, queryRisky, queryTask, queryRiskyTask

@docs Mutation, mutation, mutationRisky, mutationTask, mutationRiskyTask

@docs Subscription, subscription

@docs Error

@docs queryString


## Internal encoding and decoding

@docs Argument, maybeScalarEncode

@docs decodeNullable

@docs Request, toRequest, send, simulate, mapRequest

@docs Option, InputObject, inputObject, addField, addOptionalField, encodeInputObjectAsJson, inputObjectToFieldList

@docs andMap, versionedJsonField, versionedName, versionedAlias

@docs bakeToSelection

-}

import Dict exposing (Dict)
import Http
import Json.Decode
import Json.Encode
import Set
import Task exposing (Task)


{-| Batch a number of selection sets together!
-}
batch : List (Selection source data) -> Selection source (List data)
batch selections =
    Selection <|
        Details
            (List.foldl
                (\(Selection (Details newOpName _ _)) maybeOpName ->
                    mergeOpNames maybeOpName newOpName
                )
                Nothing
                selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ toFieldsGql _)) cursor ->
                        let
                            new =
                                toFieldsGql cursor.context
                        in
                        { context = new.context
                        , fields = cursor.fields ++ new.fields
                        , fragments = cursor.fragments ++ new.fragments
                        }
                    )
                    { context = context
                    , fields = []
                    , fragments = ""
                    }
                    selections
            )
            (\context ->
                List.foldl
                    (\(Selection (Details _ _ toItemDecoder)) ( ctxt, cursorFieldsDecoder ) ->
                        let
                            ( newCtxt, itemDecoder ) =
                                toItemDecoder ctxt
                        in
                        ( newCtxt
                        , cursorFieldsDecoder
                            |> Json.Decode.andThen
                                (\existingList ->
                                    Json.Decode.map
                                        (\item ->
                                            item :: existingList
                                        )
                                        itemDecoder
                                )
                        )
                    )
                    ( context, Json.Decode.succeed [] )
                    selections
            )


findFirstMatch : List ( String, item ) -> String -> Json.Decode.Decoder item
findFirstMatch options str =
    case options of
        [] ->
            Json.Decode.fail ("Unexpected enum value: " ++ str)

        ( name, value ) :: remaining ->
            if name == str then
                Json.Decode.succeed value

            else
                findFirstMatch remaining str


type Variable
    = Variable String


{-| -}
type Selection source selected
    = Selection (Details selected)


type alias Context =
    { version : Int
    , aliases : Dict String Int
    , variables : Dict String VariableDetails
    }


type alias VariableDetails =
    { gqlTypeName : String
    , value : Maybe Json.Encode.Value
    }


empty : Context
empty =
    { aliases = Dict.empty
    , version = 0
    , variables = Dict.empty
    }


{-| -}
select : data -> Selection source data
select data =
    Selection
        (Details Nothing
            (\context ->
                { context = context
                , fields = []
                , fragments = ""
                }
            )
            (\context ->
                ( context, Json.Decode.succeed data )
            )
        )


withName : String -> Selection source data -> Selection source data
withName name (Selection (Details _ toGql toDecoder)) =
    Selection (Details (Just name) toGql toDecoder)


{-| An unguarded GQL query.
-}
type Details selected
    = Details
        -- This is an optional *operation name*
        -- Can only be set on Queries and Mutations
        (Maybe String)
        -- Both of these take a Set String, which is how we're keeping track of
        -- what needs to be aliased
        -- How to make the gql query
        (Context
         ->
            { context : Context
            , fields : List Field
            , fragments : String
            }
        )
        -- How to decode the data coming back
        (Context -> ( Context, Json.Decode.Decoder selected ))


type Field
    = --    name   alias          args                        children
      Field String (Maybe String) (List ( String, Variable )) (List Field)
      --        ...on FragmentName
    | Fragment String (List Field)
      -- a piece of GQL that has been validated separately
      -- This is generally for operational gql
    | Baked String


{-| We can also accept:

  - Enum values (unquoted)
  - custom scalars

But we can define anything else in terms of these:

-}
type Argument obj
    = ArgValue Json.Encode.Value String
    | Var String


{-| -}
type Option value
    = Present value
    | Null
    | Absent


{-| -}
type InputObject value
    = InputObject String (List ( String, VariableDetails ))


{-| -}
inputObject : String -> InputObject value
inputObject name =
    InputObject name []


{-| -}
addField : String -> String -> Json.Encode.Value -> InputObject value -> InputObject value
addField fieldName gqlFieldType val (InputObject name inputFields) =
    InputObject name
        (inputFields
            ++ [ ( fieldName
                 , { gqlTypeName = gqlFieldType
                   , value = Just val
                   }
                 )
               ]
        )


{-| -}
addOptionalField : String -> String -> Option value -> (value -> Json.Encode.Value) -> InputObject input -> InputObject input
addOptionalField fieldName gqlFieldType optionalValue toJsonValue (InputObject name inputFields) =
    let
        newField =
            case optionalValue of
                Absent ->
                    ( fieldName, { value = Nothing, gqlTypeName = gqlFieldType } )

                Null ->
                    ( fieldName, { value = Just Json.Encode.null, gqlTypeName = gqlFieldType } )

                Present val ->
                    ( fieldName, { value = Just (toJsonValue val), gqlTypeName = gqlFieldType } )
    in
    InputObject name (inputFields ++ [ newField ])


{-| -}
type Optional arg
    = Optional String (Argument arg)


{-| -}
inputObjectToFieldList : InputObject a -> List ( String, VariableDetails )
inputObjectToFieldList (InputObject _ fields) =
    fields


{-| -}
encodeInputObjectAsJson : InputObject value -> Json.Decode.Value
encodeInputObjectAsJson (InputObject _ fields) =
    fields
        |> List.filterMap
            (\( varName, var ) ->
                case var.value of
                    Nothing ->
                        Nothing

                    Just value ->
                        Just ( varName, value )
            )
        |> Json.Encode.object


{-| -}
encodeOptionals : List (Optional arg) -> List ( String, Argument arg )
encodeOptionals opts =
    List.foldl
        (\(Optional optName argument) (( found, gathered ) as skip) ->
            if Set.member optName found then
                skip

            else
                ( Set.insert optName found
                , ( optName, argument ) :: gathered
                )
        )
        ( Set.empty, [] )
        opts
        |> Tuple.second


{-| -}
map : (a -> b) -> Selection source a -> Selection source b
map fn (Selection (Details maybeOpName fields decoder)) =
    Selection <|
        Details maybeOpName
            fields
            (\aliases ->
                let
                    ( newAliases, newDecoder ) =
                        decoder aliases
                in
                ( newAliases, Json.Decode.map fn newDecoder )
            )


mergeOpNames : Maybe String -> Maybe String -> Maybe String
mergeOpNames maybeOne maybeTwo =
    case ( maybeOne, maybeTwo ) of
        ( Nothing, Nothing ) ->
            Nothing

        ( Just one, _ ) ->
            Just one

        ( _, Just two ) ->
            Just two


{-| -}
map2 : (a -> b -> c) -> Selection source a -> Selection source b -> Selection source c
map2 fn (Selection (Details oneOpName oneFields oneDecoder)) (Selection (Details twoOpName twoFields twoDecoder)) =
    Selection <|
        Details
            (mergeOpNames oneOpName twoOpName)
            (\aliases ->
                let
                    one =
                        oneFields aliases

                    two =
                        twoFields one.context
                in
                { context = two.context
                , fields = one.fields ++ two.fields
                , fragments = one.fragments ++ two.fragments
                }
            )
            (\aliases ->
                let
                    ( oneAliasesNew, oneDecoderNew ) =
                        oneDecoder aliases

                    ( twoAliasesNew, twoDecoderNew ) =
                        twoDecoder oneAliasesNew
                in
                ( twoAliasesNew
                , Json.Decode.map2 fn oneDecoderNew twoDecoderNew
                )
            )


{-| -}
bakeToSelection :
    Maybe String
    ->
        (Int
         ->
            { args : List ( String, VariableDetails )
            , body : String
            , fragments : String
            }
        )
    -> (Int -> Json.Decode.Decoder data)
    -> Selection source data
bakeToSelection maybeOpName toGql toDecoder =
    Selection
        (Details maybeOpName
            (\context ->
                let
                    gql =
                        toGql context.version
                in
                { context =
                    { context
                        | version = context.version + 1
                        , variables =
                            gql.args
                                |> List.map (protectArgs context.version)
                                |> Dict.fromList
                                |> Dict.union context.variables
                    }
                , fields = [ Baked gql.body ]
                , fragments = gql.fragments
                }
            )
            (\context ->
                let
                    decoder =
                        toDecoder context.version
                in
                ( { context
                    | version = context.version + 1
                  }
                , decoder
                )
            )
        )


protectArgs : Int -> ( String, VariableDetails ) -> ( String, VariableDetails )
protectArgs version ( name, var ) =
    ( versionedName version name, var )



{- Making requests -}


{-| -}
type Query
    = Query


{-| -}
type Mutation
    = Mutation


{-| -}
type Subscription
    = Subscription


{-| -}
type Request value
    = Request
        { method : String
        , headers : List ( String, String )
        , url : String
        , body : Json.Encode.Value
        , expect : Http.Response String -> Result Error value
        , timeout : Maybe Float
        , tracker : Maybe String
        }


{-| -}
mapRequest : (a -> b) -> Request a -> Request b
mapRequest fn (Request request) =
    Request
        { method = request.method
        , headers = request.headers
        , url = request.url
        , body = request.body
        , expect = request.expect >> Result.map fn
        , timeout = request.timeout
        , tracker = request.tracker
        }


{-| -}
send : Request data -> Cmd (Result Error data)
send (Request req) =
    Http.request
        { method = req.method
        , headers = List.map (\( key, val ) -> Http.header key val) req.headers
        , url = req.url
        , body = Http.jsonBody req.body
        , expect =
            Http.expectStringResponse identity req.expect
        , timeout = req.timeout
        , tracker = req.tracker
        }


{-| -}
simulate :
    { toHeader : String -> String -> header
    , toExpectation : (Http.Response String -> Result Error value) -> expectation
    , toBody : Json.Encode.Value -> body
    , toRequest :
        { method : String
        , headers : List header
        , url : String
        , body : body
        , expect : expectation
        , timeout : Maybe Float
        , tracker : Maybe String
        }
        -> simulated
    }
    -> Request value
    -> simulated
simulate config (Request req) =
    config.toRequest
        { method = req.method
        , headers = List.map (\( key, val ) -> config.toHeader key val) req.headers
        , url = req.url
        , body = config.toBody req.body
        , expect = config.toExpectation req.expect
        , timeout = req.timeout
        , tracker = req.tracker
        }


{-| -}
subscription :
    Selection Subscription data
    ->
        { payload : Json.Encode.Value
        , decoder : Json.Decode.Decoder data
        }
subscription ((Selection (Details _ fields toDecoder)) as sel) =
    let
        ( context_, decoder ) =
            toDecoder empty
    in
    { payload = encodePayload "subscription" sel
    , decoder = decoder
    }


{-| -}
query :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error value)
query sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
mutation :
    Selection Mutation msg
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error msg)
mutation sel config =
    Http.request
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
queryTask :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
queryTask sel config =
    Http.task
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-| -}
mutationTask :
    Selection Mutation value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
mutationTask sel config =
    Http.task
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-| -}
queryRisky :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error value)
queryRisky sel config =
    Http.riskyRequest
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
mutationRisky :
    Selection Mutation msg
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        , tracker : Maybe String
        }
    -> Cmd (Result Error msg)
mutationRisky sel config =
    Http.riskyRequest
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , expect = expect identity sel
        , timeout = config.timeout
        , tracker = config.tracker
        }


{-| -}
queryRiskyTask :
    Selection Query value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
queryRiskyTask sel config =
    Http.riskyTask
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "query" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-| -}
mutationRiskyTask :
    Selection Mutation value
    ->
        { headers : List Http.Header
        , url : String
        , timeout : Maybe Float
        }
    -> Task Error value
mutationRiskyTask sel config =
    Http.riskyTask
        { method = "POST"
        , headers = config.headers
        , url = config.url
        , body = body "mutation" sel
        , resolver = resolver sel
        , timeout = config.timeout
        }


{-|

      Http.request
        { method = "POST"
        , headers = []
        , url = "https://example.com/gql-endpoint"
        , body = Gql.body query
        , expect = Gql.expect Received query
        , timeout = Nothing
        , tracker = Nothing
        }

-}
body : String -> Selection source data -> Http.Body
body operation q =
    Http.jsonBody
        (encodePayload operation q)


encodePayload : String -> Selection source data -> Json.Encode.Value
encodePayload operation q =
    let
        variables : Dict String VariableDetails
        variables =
            (getContext q).variables
    in
    Json.Encode.object
        [ ( "query", Json.Encode.string (queryString operation q) )
        , ( "variables", encodeVariables variables )
        ]


encodeVariables : Dict String VariableDetails -> Json.Encode.Value
encodeVariables variables =
    variables
        |> Dict.toList
        |> List.filterMap
            (\( varName, var ) ->
                case var.value of
                    Nothing ->
                        Nothing

                    Just value ->
                        Just ( varName, value )
            )
        |> Json.Encode.object


getContext : Selection source selected -> Context
getContext (Selection (Details maybeOpName gql _)) =
    let
        rendered =
            gql empty
    in
    rendered.context


{-| -}
expect : (Result Error data -> msg) -> Selection source data -> Http.Expect msg
expect toMsg (Selection (Details maybeOpName gql toDecoder)) =
    let
        ( context, decoder ) =
            toDecoder empty
    in
    Http.expectStringResponse toMsg (responseToResult decoder)


{-| -}
resolver : Selection source data -> Http.Resolver Error data
resolver (Selection (Details maybeOpName gql toDecoder)) =
    let
        ( context, decoder ) =
            toDecoder empty
    in
    Http.stringResolver (responseToResult decoder)


responseToResult : Json.Decode.Decoder data -> Http.Response String -> Result Error data
responseToResult decoder response =
    case response of
        Http.BadUrl_ url ->
            Err (BadUrl url)

        Http.Timeout_ ->
            Err Timeout

        Http.NetworkError_ ->
            Err NetworkError

        Http.BadStatus_ metadata responseBody ->
            Err
                (BadStatus
                    { status = metadata.statusCode
                    , responseBody = responseBody
                    }
                )

        Http.GoodStatus_ metadata responseBody ->
            case Json.Decode.decodeString (Json.Decode.field "data" decoder) responseBody of
                Ok value ->
                    Ok value

                Err err ->
                    Err
                        (BadBody
                            { responseBody = responseBody
                            , decodingError = Json.Decode.errorToString err
                            }
                        )


{-| -}
type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus
        { status : Int
        , responseBody : String
        }
    | BadBody
        { decodingError : String
        , responseBody : String
        }


{-| -}
queryString : String -> Selection source data -> String
queryString operation (Selection (Details maybeOpName gql _)) =
    let
        rendered =
            gql empty
    in
    operation
        ++ " "
        ++ Maybe.withDefault "" maybeOpName
        ++ renderParameters rendered.context.variables
        ++ "{"
        ++ fieldsToQueryString rendered.fields ""
        ++ "}"
        ++ rendered.fragments


renderParameters : Dict String VariableDetails -> String
renderParameters dict =
    let
        paramList =
            Dict.toList dict
    in
    case paramList of
        [] ->
            ""

        _ ->
            "(" ++ renderParametersHelper paramList "" ++ ")"


renderParametersHelper : List ( String, VariableDetails ) -> String -> String
renderParametersHelper args rendered =
    case args of
        [] ->
            rendered

        ( name, value ) :: remaining ->
            if String.isEmpty rendered then
                renderParametersHelper remaining ("$" ++ name ++ ":" ++ value.gqlTypeName)

            else
                renderParametersHelper remaining (rendered ++ ", $" ++ name ++ ":" ++ value.gqlTypeName)


fieldsToQueryString : List Field -> String -> String
fieldsToQueryString fields rendered =
    case fields of
        [] ->
            rendered

        top :: remaining ->
            if String.isEmpty rendered then
                fieldsToQueryString remaining (renderField top)

            else
                fieldsToQueryString remaining (rendered ++ "\n" ++ renderField top)


renderField : Field -> String
renderField myField =
    case myField of
        Baked q ->
            q

        Fragment name fields ->
            "... on "
                ++ name
                ++ "{"
                ++ fieldsToQueryString fields ""
                ++ "}"

        Field name maybeAlias args fields ->
            let
                aliasString =
                    maybeAlias
                        |> Maybe.map (\a -> a ++ ":")
                        |> Maybe.withDefault ""

                argString =
                    case args of
                        [] ->
                            ""

                        nonEmpty ->
                            "(" ++ renderArgs nonEmpty "" ++ ")"

                selection =
                    case fields of
                        [] ->
                            ""

                        _ ->
                            "{" ++ fieldsToQueryString fields "" ++ "}"
            in
            aliasString ++ name ++ argString ++ selection


renderArgs : List ( String, Variable ) -> String -> String
renderArgs args rendered =
    case args of
        [] ->
            rendered

        ( name, Variable varName ) :: remaining ->
            if String.isEmpty rendered then
                renderArgs remaining (rendered ++ name ++ ": $" ++ varName)

            else
                renderArgs remaining (rendered ++ ", " ++ name ++ ": $" ++ varName)


{-| -}
maybeScalarEncode : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
maybeScalarEncode encoder maybeA =
    maybeA
        |> Maybe.map encoder
        |> Maybe.withDefault Json.Encode.null


{-| -}
decodeNullable : Json.Decode.Decoder data -> Json.Decode.Decoder (Maybe data)
decodeNullable =
    Json.Decode.nullable


versionedJsonField :
    Int
    -> String
    -> Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
versionedJsonField int name new build =
    Json.Decode.map2
        (\a fn -> fn a)
        (Json.Decode.field (versionedName int name) new)
        build


versionedName : Int -> String -> String
versionedName i name =
    if i == 0 then
        name

    else
        name ++ "_batch_" ++ String.fromInt i


{-| Slightly different than versioned name, this is specific to only making an alias if the version is not 0.

so if I'm selecting a field "myField"

Then

    versionedAlias 0 "myField"
        -> "myField"

but

    versionedAlias 1 "myField"
        -> "myField\_batch\_1: myField"

-}
versionedAlias : Int -> String -> String
versionedAlias i name =
    if i == 0 then
        name

    else
        name ++ "_batch_" ++ String.fromInt i ++ ": " ++ name


andMap :
    Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
andMap new build =
    Json.Decode.map2
        (\a fn -> fn a)
        new
        build
