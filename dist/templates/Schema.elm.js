"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = (function () { return "module GraphQL.Schema exposing\n    ( getJsonValue\n    , Mutation, Query, decoder, empty\n    , Kind(..), Schema, Type(..), isScalar\n    , mockScalar\n    , Wrapped(..), getWrap, getInner\n    , Argument, Field, InputObjectDetails, InterfaceDetails, Namespace, ObjectDetails, ScalarDetails, UnionDetails, Variant, kindToString, typeToElmString, typeToString\n    )\n\n{-|\n\n@docs getJsonValue\n\n@docs Mutation, Query, decoder, empty\n\n@docs Kind, Schema, Type, isScalar\n\n@docs mockScalar\n\n@docs Wrapped, getWrap, getInner\n\n-}\n\nimport Dict exposing (Dict)\nimport Http\nimport Json.Decode as Json\nimport Json.Encode\n\n\ntype alias Namespace =\n    { namespace : String\n    , enums : String\n    }\n\n\n\n-- Definition\n\n\ntype alias Schema =\n    { queries : Dict Ref Query\n    , mutations : Dict Ref Mutation\n    , objects : Dict Ref ObjectDetails\n    , scalars : Dict Ref ScalarDetails\n    , inputObjects : Dict Ref InputObjectDetails\n    , enums : Dict Ref EnumDetails\n    , unions : Dict Ref UnionDetails\n    , interfaces : Dict Ref InterfaceDetails\n    }\n\n\ntype Deprecation\n    = Deprecated (Maybe String)\n    | Active\n\n\ntype alias ScalarDetails =\n    { name : String\n    , description : Maybe String\n    }\n\n\ntype alias UnionDetails =\n    { name : String\n    , description : Maybe String\n    , variants : List Variant\n    }\n\n\ntype alias Variant =\n    { kind : Kind\n    }\n\n\ntype alias ObjectDetails =\n    { name : String\n    , description : Maybe String\n    , fields : List Field\n    , interfaces : List Kind\n    }\n\n\ntype alias Argument =\n    { name : String\n    , description : Maybe String\n    , type_ : Type\n    }\n\n\ntype alias Field =\n    { name : String\n    , deprecation : Deprecation\n    , description : Maybe String\n    , arguments : List Argument\n    , type_ : Type\n    , permissions : List Permission\n    }\n\n\ntype alias InterfaceDetails =\n    { name : String\n    , description : Maybe String\n    , fields : List Field\n    , implementedBy : List Kind\n    }\n\n\ntype alias EnumDetails =\n    { name : String\n    , description : Maybe String\n    , values : List Value\n    }\n\n\ntype alias Value =\n    { name : String\n    , description : Maybe String\n    }\n\n\ntype Kind\n    = ObjectKind String\n    | ScalarKind String\n    | InputObjectKind String\n    | EnumKind String\n    | UnionKind String\n    | InterfaceKind String\n\n\ntype Type\n    = Scalar String\n    | InputObject String\n    | Object String\n    | Enum String\n    | Union String\n    | Interface String\n    | List_ Type\n    | Nullable Type\n\n\ntype alias Permission =\n    String\n\n\ntype alias InputObjectDetails =\n    { name : String\n    , description : Maybe String\n    , fields : List Field\n    , isOneOf : Bool\n    }\n\n\n\n{- Helpers -}\n\n\ntype OperationType\n    = Query\n    | Mutation\n\n\noperationTypeToString : OperationType -> String\noperationTypeToString op =\n    case op of\n        Query ->\n            \"Query\"\n\n        Mutation ->\n            \"Mutation\"\n\n\ntype Wrapped\n    = UnwrappedValue\n    | InList Wrapped\n    | InMaybe Wrapped\n\n\nisScalar : Type -> Bool\nisScalar tipe =\n    case tipe of\n        Scalar _ ->\n            True\n\n        Nullable inner ->\n            isScalar inner\n\n        List_ inner ->\n            isScalar inner\n\n        _ ->\n            False\n\n\ngetWrap : Type -> Wrapped\ngetWrap type_ =\n    case type_ of\n        Nullable newType ->\n            InMaybe (getWrap newType)\n\n        List_ newType ->\n            InList (getWrap newType)\n\n        _ ->\n            UnwrappedValue\n\n\ngetInner : Type -> Type\ngetInner type_ =\n    case type_ of\n        Nullable newType ->\n            getInner newType\n\n        List_ newType ->\n            getInner newType\n\n        inner ->\n            inner\n\n\nmockScalar : Type -> Json.Encode.Value\nmockScalar t =\n    case t of\n        Scalar name ->\n            case String.toLower name of\n                \"int\" ->\n                    Json.Encode.int 5\n\n                \"float\" ->\n                    Json.Encode.float 5\n\n                \"boolean\" ->\n                    Json.Encode.bool True\n\n                \"id\" ->\n                    Json.Encode.string \"<id>\"\n\n                \"datetime\" ->\n                    Json.Encode.string \"2022-04-04T21:38:43.195Z\"\n\n                _ ->\n                    Json.Encode.string (\"SCALAR:\" ++ name)\n\n        InputObject name ->\n            Json.Encode.null\n\n        Object name ->\n            Json.Encode.null\n\n        Enum name ->\n            Json.Encode.null\n\n        Union name ->\n            Json.Encode.null\n\n        Interface name ->\n            Json.Encode.null\n\n        List_ inner ->\n            Json.Encode.list mockScalar [ inner ]\n\n        Nullable inner ->\n            mockScalar inner\n\n\ntypeToElmString : Type -> String\ntypeToElmString t =\n    case t of\n        Scalar \"Boolean\" ->\n            \"Bool\"\n\n        Scalar name ->\n            name\n\n        InputObject name ->\n            name\n\n        Object name ->\n            name\n\n        Enum name ->\n            name\n\n        Union name ->\n            name\n\n        Interface name ->\n            name\n\n        List_ inner ->\n            \"(List \" ++ typeToElmString inner ++ \")\"\n\n        Nullable inner ->\n            \"(Maybe \" ++ typeToElmString inner ++ \")\"\n\n\ntypeToString : Type -> String\ntypeToString tipe =\n    typeToStringHelper False tipe\n\n\ntypeToStringHelper : Bool -> Type -> String\ntypeToStringHelper nullable tipe =\n    let\n        required str =\n            if nullable then\n                str\n\n            else\n                str ++ \"!\"\n    in\n    case tipe of\n        Scalar name ->\n            required name\n\n        InputObject name ->\n            required name\n\n        Object name ->\n            required name\n\n        Enum name ->\n            required name\n\n        Union name ->\n            required name\n\n        Interface name ->\n            required name\n\n        List_ inner ->\n            required (\"[\" ++ typeToStringHelper False inner ++ \"]\")\n\n        Nullable inner ->\n            typeToStringHelper True inner\n\n\nbrackets : String -> String\nbrackets str =\n    \"{\" ++ str ++ \"}\"\n\n\ntype Wrapper\n    = WithinList { required : Bool } Wrapper\n    | Val { required : Bool }\n\n\n{-|\n\n    Type ->\n        Required Val\n\n    Nullable Type ->\n        Val\n\n-}\ngetWrapper : Type -> Wrapper -> Wrapper\ngetWrapper t wrap =\n    case t of\n        Scalar name ->\n            wrap\n\n        InputObject name ->\n            wrap\n\n        Object name ->\n            wrap\n\n        Enum name ->\n            wrap\n\n        Union name ->\n            wrap\n\n        Interface name ->\n            wrap\n\n        List_ inner ->\n            getWrapper inner (WithinList { required = True } wrap)\n\n        Nullable inner ->\n            case wrap of\n                Val { required } ->\n                    getWrapper inner (Val { required = False })\n\n                WithinList { required } wrapper ->\n                    getWrapper inner (WithinList { required = False } wrapper)\n\n\n\n{- End of schema, below are intermediate data structures -}\n\n\ntype alias Ref =\n    String\n\n\ntype SchemaGrouping\n    = Query_Group (Dict String Query)\n    | Mutation_Group (Dict String Mutation)\n    | Object_Group ObjectDetails\n    | Scalar_Group ScalarDetails\n    | InputObject_Group InputObjectDetails\n    | Enum_Group EnumDetails\n    | Union_Group UnionDetails\n    | Interface_Group InterfaceDetails\n\n\ntype alias Query =\n    Field\n\n\ntype alias Mutation =\n    Field\n\n\ndecoder : Json.Decoder Schema\ndecoder =\n    Json.oneOf\n        [ Json.field \"__schema\"\n            (namesDecoder\n                |> Json.andThen grabTypes\n            )\n        , Json.at [ \"data\", \"__schema\" ]\n            (namesDecoder\n                |> Json.andThen grabTypes\n            )\n        ]\n\n\nnamesDecoder : Json.Decoder Names\nnamesDecoder =\n    Json.succeed Names\n        |> apply (Json.at [ \"queryType\", \"name\" ] Json.string)\n        |> apply\n            (Json.field \"mutationType\"\n                (Json.oneOf\n                    [ Json.map Just (Json.field \"name\" Json.string)\n                    , Json.null Nothing\n                    ]\n                )\n            )\n\n\ntype alias Names =\n    { queryName : String\n    , mutationName : Maybe String\n    }\n\n\ngrabTypes : Names -> Json.Decoder Schema\ngrabTypes names =\n    let\n        loop : ( String, SchemaGrouping ) -> Schema -> Schema\n        loop ( name, kind ) schema =\n            case kind of\n                Query_Group queries ->\n                    { schema | queries = queries }\n\n                Mutation_Group mutations ->\n                    { schema | mutations = mutations }\n\n                Object_Group object ->\n                    { schema\n                        | objects =\n                            if String.startsWith \"__\" name then\n                                schema.objects\n\n                            else\n                                Dict.insert name object schema.objects\n                    }\n\n                Scalar_Group scalar ->\n                    { schema | scalars = Dict.insert name scalar schema.scalars }\n\n                InputObject_Group inputObject ->\n                    { schema | inputObjects = Dict.insert name inputObject schema.inputObjects }\n\n                Enum_Group enum ->\n                    { schema | enums = Dict.insert name enum schema.enums }\n\n                Union_Group union ->\n                    { schema | unions = Dict.insert name union schema.unions }\n\n                Interface_Group interface ->\n                    { schema | interfaces = Dict.insert name interface schema.interfaces }\n    in\n    kinds names\n        |> Json.map (List.foldl loop empty)\n\n\nkinds : Names -> Json.Decoder (List ( String, SchemaGrouping ))\nkinds names =\n    let\n        kind : Json.Decoder (Maybe ( String, SchemaGrouping ))\n        kind =\n            Json.field \"name\" Json.string\n                |> Json.andThen\n                    (\\name ->\n                        Json.field \"kind\" Json.string\n                            |> Json.andThen (fromNameAndKind name)\n                            |> Json.map (\\kind_ -> kind_ |> Maybe.map (Tuple.pair name))\n                    )\n\n        fromNameAndKind : String -> String -> Json.Decoder (Maybe SchemaGrouping)\n        fromNameAndKind name_ k =\n            case k of\n                \"OBJECT\" ->\n                    if name_ == names.queryName then\n                        Json.map Query_Group decodeOperation |> Json.map Just\n\n                    else if Just name_ == names.mutationName then\n                        Json.map Mutation_Group decodeOperation |> Json.map Just\n\n                    else\n                        filterHidden (Json.map Object_Group decodeObject)\n\n                \"SCALAR\" ->\n                    filterHidden (Json.map Scalar_Group decodeScalar)\n\n                \"INTERFACE\" ->\n                    filterHidden (Json.map Interface_Group decodeInterface)\n\n                \"INPUT_OBJECT\" ->\n                    filterHidden (Json.map InputObject_Group decodeInputObject)\n\n                \"ENUM\" ->\n                    filterHidden (Json.map Enum_Group decodeEnum)\n\n                \"UNION\" ->\n                    filterHidden (Json.map Union_Group decodeUnion)\n\n                _ ->\n                    Json.fail (\"Didnt recognize kind: \" ++ k)\n    in\n    Json.field \"types\"\n        (Json.list kind |> Json.map (List.filterMap identity))\n\n\nempty : Schema\nempty =\n    { queries = Dict.empty\n    , mutations = Dict.empty\n    , objects = Dict.empty\n    , scalars = Dict.empty\n    , inputObjects = Dict.empty\n    , enums = Dict.empty\n    , unions = Dict.empty\n    , interfaces = Dict.empty\n    }\n\n\ngetJsonValue : List ( String, String ) -> String -> (Result Http.Error Json.Value -> msg) -> Cmd msg\ngetJsonValue headers url toMsg =\n    Http.request\n        { method = \"POST\"\n        , headers = headers |> List.map (\\( key, val ) -> Http.header key val)\n        , url = url\n        , body =\n            Http.jsonBody\n                (Json.Encode.object\n                    [ ( \"query\", Json.Encode.string introspection )\n                    ]\n                )\n        , expect = Http.expectJson toMsg Json.value\n        , timeout = Nothing\n        , tracker = Nothing\n        }\n\n\nintrospection : String\nintrospection =\n    \"\"\"\nquery IntrospectionQuery {\n    __schema {\n      queryType {\n        name\n      }\n      mutationType {\n        name\n      }\n      subscriptionType {\n        name\n      }\n      types {\n        ...FullType\n      }\n    }\n  }\n  fragment FullType on __Type {\n    kind\n    name\n    description\n    fields(includeDeprecated: true) {\n      name\n      description\n      args {\n        ...InputValue\n      }\n      type {\n        ...TypeRef\n      }\n      isDeprecated\n      deprecationReason\n    }\n    inputFields {\n      ...InputValue\n    }\n    interfaces {\n      ...TypeRef\n    }\n    enumValues(includeDeprecated: true) {\n      name\n      description\n      isDeprecated\n      deprecationReason\n    }\n    possibleTypes {\n      ...TypeRef\n    }\n  }\n  fragment InputValue on __InputValue {\n    name\n    description\n    type {\n      ...TypeRef\n    }\n    defaultValue\n  }\n  fragment TypeRef on __Type {\n    kind\n    name\n    ofType {\n      kind\n      name\n      ofType {\n        kind\n        name\n        ofType {\n          kind\n          name\n          ofType {\n            kind\n            name\n            ofType {\n              kind\n              name\n              ofType {\n                kind\n                name\n                ofType {\n                  kind\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n\"\"\"\n\n\ndecodeScalar : Json.Decoder ScalarDetails\ndecodeScalar =\n    Json.map2 ScalarDetails\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n\n\nkindFromNameAndString : String -> String -> Json.Decoder Kind\nkindFromNameAndString name_ kind =\n    case kind of\n        \"OBJECT\" ->\n            Json.succeed (ObjectKind name_)\n\n        \"SCALAR\" ->\n            Json.succeed (ScalarKind name_)\n\n        \"INTERFACE\" ->\n            Json.succeed (InterfaceKind name_)\n\n        \"INPUT_OBJECT\" ->\n            Json.succeed (InputObjectKind name_)\n\n        \"ENUM\" ->\n            Json.succeed (EnumKind name_)\n\n        \"UNION\" ->\n            Json.succeed (UnionKind name_)\n\n        _ ->\n            Json.fail (\"Didn't recognize variant kind: \" ++ kind)\n\n\ndecodeKind : Json.Decoder Kind\ndecodeKind =\n    Json.field \"name\" Json.string\n        |> Json.andThen\n            (\\n ->\n                Json.field \"kind\" Json.string\n                    |> Json.andThen (kindFromNameAndString n)\n            )\n\n\nkindToString : Kind -> String\nkindToString kind =\n    case kind of\n        ObjectKind name_ ->\n            name_\n\n        ScalarKind name_ ->\n            name_\n\n        InputObjectKind name_ ->\n            name_\n\n        EnumKind name_ ->\n            name_\n\n        UnionKind name_ ->\n            name_\n\n        InterfaceKind name_ ->\n            name_\n\n\nnameOf : Kind -> String\nnameOf kind =\n    case kind of\n        ObjectKind _ ->\n            \"Objects\"\n\n        ScalarKind _ ->\n            \"Scalars\"\n\n        InputObjectKind _ ->\n            \"Input Objects\"\n\n        EnumKind _ ->\n            \"Enums\"\n\n        UnionKind _ ->\n            \"Unions\"\n\n        InterfaceKind _ ->\n            \"Interfaces\"\n\n\ndecodeUnion : Json.Decoder UnionDetails\ndecodeUnion =\n    Json.map3 UnionDetails\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n        (Json.field \"possibleTypes\" (Json.list decodeVariant))\n\n\ndecodeVariant : Json.Decoder Variant\ndecodeVariant =\n    Json.map Variant\n        decodeKind\n\n\ndecodeObject : Json.Decoder ObjectDetails\ndecodeObject =\n    Json.map4 ObjectDetails\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n        (Json.field \"fields\" (Json.list decodeField))\n        (Json.field \"interfaces\" (Json.list decodeInterfaceKind))\n\n\ndecodeInterfaceKind : Json.Decoder Kind\ndecodeInterfaceKind =\n    Json.field \"name\" Json.string\n        |> Json.map InterfaceKind\n\n\ndecodeEnum : Json.Decoder EnumDetails\ndecodeEnum =\n    Json.map3 EnumDetails\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n        (Json.field \"enumValues\" (Json.list decodeValue))\n\n\ndecodeValue : Json.Decoder Value\ndecodeValue =\n    Json.map2 Value\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n\n\ndecodeOperation : Json.Decoder (Dict String Field)\ndecodeOperation =\n    let\n        tupleDecoder : Json.Decoder ( String, Field )\n        tupleDecoder =\n            Json.map2 Tuple.pair\n                (Json.field \"name\" Json.string)\n                decodeField\n    in\n    Json.map Dict.fromList\n        (Json.field \"fields\"\n            (Json.list tupleDecoder)\n        )\n\n\n\n{- Field Decoder -}\n\n\ndecodeField : Json.Decoder Field\ndecodeField =\n    Json.map6 Field\n        (Json.field \"name\" Json.string)\n        (Json.maybe decodeDeprecation\n            |> Json.map\n                (\\maybeDeprecated ->\n                    case maybeDeprecated of\n                        Nothing ->\n                            Active\n\n                        Just dep ->\n                            dep\n                )\n        )\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n        (Json.oneOf\n            [ Json.field \"args\" (Json.list decodeArgument)\n            , Json.succeed []\n            ]\n        )\n        (Json.field \"type\" decodeType)\n        decodePermission\n\n\ndecodePermission : Json.Decoder (List Permission)\ndecodePermission =\n    Json.list Json.string\n        |> Json.at [ \"directives\", \"requires\", \"permissions\" ]\n        |> Json.maybe\n        |> Json.map (Maybe.withDefault [])\n\n\ndecodeInterface : Json.Decoder InterfaceDetails\ndecodeInterface =\n    Json.map4 InterfaceDetails\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe Json.string))\n        (Json.field \"fields\" (Json.list decodeField))\n        (Json.field \"possibleTypes\" (Json.list decodeKind))\n\n\ndecodeDeprecation : Json.Decoder Deprecation\ndecodeDeprecation =\n    let\n        fromBoolean : Bool -> Json.Decoder Deprecation\n        fromBoolean isDeprecated_ =\n            if isDeprecated_ then\n                Json.map Deprecated\n                    (Json.maybe (Json.field \"deprecationReason\" Json.string))\n\n            else\n                Json.succeed Active\n    in\n    Json.field \"isDeprecated\" Json.bool\n        |> Json.andThen fromBoolean\n\n\nisDeprecated : Deprecation -> Bool\nisDeprecated deprecation =\n    case deprecation of\n        Deprecated _ ->\n            True\n\n        Active ->\n            False\n\n\ndecodeInputObject : Json.Decoder InputObjectDetails\ndecodeInputObject =\n    Json.map4 InputObjectDetails\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n        (Json.field \"inputFields\" (Json.list decodeField))\n        (Json.maybe\n            (Json.field \"oneField\" Json.bool)\n            |> Json.map (Maybe.withDefault False)\n        )\n\n\ndecodeArgument : Json.Decoder Argument\ndecodeArgument =\n    Json.map3 Argument\n        (Json.field \"name\" Json.string)\n        (Json.field \"description\" (Json.maybe nonEmptyString))\n        (Json.field \"type\" decodeType)\n\n\n\n{- Handle inverting the types -}\n\n\ndecodeType : Json.Decoder Type\ndecodeType =\n    innerDecoder\n        |> Json.map invert\n\n\ntype Inner_Type\n    = Inner_Scalar String\n    | Inner_InputObject String\n    | Inner_Object String\n    | Inner_Enum String\n    | Inner_Union String\n    | Inner_Interface String\n    | Inner_List_ Inner_Type\n    | Inner_Non_Null Inner_Type\n\n\ninnerDecoder : Json.Decoder Inner_Type\ninnerDecoder =\n    Json.field \"kind\" Json.string\n        |> Json.andThen fromKind\n\n\nfromKind : String -> Json.Decoder Inner_Type\nfromKind kind =\n    case kind of\n        \"SCALAR\" ->\n            Json.map Inner_Scalar nameDecoder\n\n        \"INPUT_OBJECT\" ->\n            Json.map Inner_InputObject nameDecoder\n\n        \"OBJECT\" ->\n            Json.map Inner_Object nameDecoder\n\n        \"ENUM\" ->\n            Json.map Inner_Enum nameDecoder\n\n        \"UNION\" ->\n            Json.map Inner_Union nameDecoder\n\n        \"INTERFACE\" ->\n            Json.map Inner_Interface nameDecoder\n\n        \"LIST\" ->\n            Json.map Inner_List_ (Json.field \"ofType\" lazyDecoder)\n\n        \"NON_NULL\" ->\n            Json.map Inner_Non_Null (Json.field \"ofType\" lazyDecoder)\n\n        _ ->\n            Json.fail (\"Unrecognized kind: \" ++ kind)\n\n\nlazyDecoder : Json.Decoder Inner_Type\nlazyDecoder =\n    Json.lazy (\\_ -> innerDecoder)\n\n\nnameDecoder : Json.Decoder String\nnameDecoder =\n    Json.field \"name\" Json.string\n\n\n\n-- Getting Kind\n\n\ntoKind : Inner_Type -> Kind\ntoKind type_ =\n    case type_ of\n        Inner_Scalar name ->\n            ScalarKind name\n\n        Inner_InputObject name ->\n            InputObjectKind name\n\n        Inner_Object name ->\n            ObjectKind name\n\n        Inner_Enum name ->\n            EnumKind name\n\n        Inner_Union name ->\n            UnionKind name\n\n        Inner_Interface name ->\n            InterfaceKind name\n\n        Inner_List_ child ->\n            toKind child\n\n        Inner_Non_Null child ->\n            toKind child\n\n\n\n-- INVERTING NULLABLE TRASH\n\n\ninvert : Inner_Type -> Type\ninvert =\n    invert_ True\n\n\ninvert_ : Bool -> Inner_Type -> Type\ninvert_ wrappedInNull inner =\n    let\n        nullable type_ =\n            if wrappedInNull then\n                Nullable type_\n\n            else\n                type_\n    in\n    case inner of\n        Inner_Non_Null inner_ ->\n            invert_ False inner_\n\n        Inner_List_ inner_ ->\n            nullable (List_ (invert_ True inner_))\n\n        Inner_Scalar value ->\n            nullable (Scalar value)\n\n        Inner_InputObject value ->\n            nullable (InputObject value)\n\n        Inner_Object value ->\n            nullable (Object value)\n\n        Inner_Enum value ->\n            nullable (Enum value)\n\n        Inner_Union value ->\n            nullable (Union value)\n\n        Inner_Interface value ->\n            nullable (Interface value)\n\n\n\n{- JSON helpers -}\n\n\napply : Json.Decoder a -> Json.Decoder (a -> b) -> Json.Decoder b\napply =\n    Json.map2 (|>)\n\n\nnonEmptyString : Json.Decoder String\nnonEmptyString =\n    Json.string\n        |> Json.andThen\n            (\\str ->\n                if String.isEmpty (String.trim str) then\n                    Json.fail \"String was empty.\"\n\n                else\n                    Json.succeed str\n            )\n\n\nfilterHidden : Json.Decoder value -> Json.Decoder (Maybe value)\nfilterHidden decoder_ =\n    let\n        filterByDirectives : Dict String Json.Value -> Json.Decoder (Maybe value)\n        filterByDirectives directives =\n            if [ \"NoDocs\", \"Unimplemented\" ] |> List.any (\\d -> Dict.member d directives) then\n                Json.succeed Nothing\n\n            else\n                Json.map Just decoder_\n    in\n    Json.oneOf\n        [ Json.field \"directives\" (Json.dict Json.value)\n            |> Json.andThen filterByDirectives\n        , Json.map Just decoder_\n        ]\n"; });
