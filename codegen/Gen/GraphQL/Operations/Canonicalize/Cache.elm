module Gen.GraphQL.Operations.Canonicalize.Cache exposing (addFragment, addLevel, addLevelKeepSiblingStack, addVars, annotation_, call_, dropLevel, dropLevelNotSiblings, enum, field, finishedDefinition, getGlobalName, init, levelFromField, make_, moduleName_, mutation, query, saveSibling, scalar, siblingCollision, subscription, values_)

{-| 
@docs values_, call_, make_, annotation_, init, finishedDefinition, addVars, addFragment, addLevelKeepSiblingStack, addLevel, dropLevel, dropLevelNotSiblings, getGlobalName, saveSibling, siblingCollision, levelFromField, query, mutation, subscription, field, scalar, enum, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize", "Cache" ]


{-| enum: String -> FilePath -> Cache -> Cache -}
enum : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
enum enumArg enumArg0 enumArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "enum"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.string enumArg, enumArg0, enumArg1 ]


{-| scalar: String -> FilePath -> Cache -> Cache -}
scalar : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
scalar scalarArg scalarArg0 scalarArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "scalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.string scalarArg, scalarArg0, scalarArg1 ]


{-| field: String -> String -> FilePath -> Cache -> Cache -}
field : String -> String -> Elm.Expression -> Elm.Expression -> Elm.Expression
field fieldArg fieldArg0 fieldArg1 fieldArg2 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.string fieldArg, Elm.string fieldArg0, fieldArg1, fieldArg2 ]


{-| subscription: String -> FilePath -> Cache -> Cache -}
subscription : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
subscription subscriptionArg subscriptionArg0 subscriptionArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "subscription"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.string subscriptionArg, subscriptionArg0, subscriptionArg1 ]


{-| mutation: String -> FilePath -> Cache -> Cache -}
mutation : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
mutation mutationArg mutationArg0 mutationArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "mutation"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.string mutationArg, mutationArg0, mutationArg1 ]


{-| query: String -> FilePath -> Cache -> Cache -}
query : String -> Elm.Expression -> Elm.Expression -> Elm.Expression
query queryArg queryArg0 queryArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "query"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.string queryArg, queryArg0, queryArg1 ]


{-| levelFromField: 
    { field | name : AST.Name, alias_ : Maybe AST.Name }
    -> { name : String, isAlias : Bool }
-}
levelFromField :
    { field | name : Elm.Expression, alias_ : Elm.Expression } -> Elm.Expression
levelFromField levelFromFieldArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "levelFromField"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "field"
                            [ ( "name", Type.namedWith [ "AST" ] "Name" [] )
                            , ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [ "AST" ] "Name" [] ]
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        )
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" levelFromFieldArg.name
            , Tuple.pair "alias_" levelFromFieldArg.alias_
            ]
        ]


{-| siblingCollision: UsedNames.Sibling -> Cache -> Bool -}
siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
siblingCollision siblingCollisionArg siblingCollisionArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        Type.bool
                    )
            }
        )
        [ siblingCollisionArg, siblingCollisionArg0 ]


{-| saveSibling: UsedNames.Sibling -> Cache -> Cache -}
saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
saveSibling saveSiblingArg saveSiblingArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ saveSiblingArg, saveSiblingArg0 ]


{-| getGlobalName: String -> Cache -> { globalName : String, used : Cache } -}
getGlobalName : String -> Elm.Expression -> Elm.Expression
getGlobalName getGlobalNameArg getGlobalNameArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "getGlobalName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "Cache" [] ]
                        (Type.record
                            [ ( "globalName", Type.string )
                            , ( "used", Type.namedWith [] "Cache" [] )
                            ]
                        )
                    )
            }
        )
        [ Elm.string getGlobalNameArg, getGlobalNameArg0 ]


{-| dropLevelNotSiblings: Cache -> Cache -}
dropLevelNotSiblings : Elm.Expression -> Elm.Expression
dropLevelNotSiblings dropLevelNotSiblingsArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "dropLevelNotSiblings"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" [] ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ dropLevelNotSiblingsArg ]


{-| dropLevel: Cache -> Cache -}
dropLevel : Elm.Expression -> Elm.Expression
dropLevel dropLevelArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "dropLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" [] ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ dropLevelArg ]


{-| addLevel: { name : String, isAlias : Bool } -> Cache -> Cache -}
addLevel : { name : String, isAlias : Bool } -> Elm.Expression -> Elm.Expression
addLevel addLevelArg addLevelArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string addLevelArg.name)
            , Tuple.pair "isAlias" (Elm.bool addLevelArg.isAlias)
            ]
        , addLevelArg0
        ]


{-| addLevelKeepSiblingStack: { name : String, isAlias : Bool } -> Cache -> Cache -}
addLevelKeepSiblingStack :
    { name : String, isAlias : Bool } -> Elm.Expression -> Elm.Expression
addLevelKeepSiblingStack addLevelKeepSiblingStackArg addLevelKeepSiblingStackArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevelKeepSiblingStack"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "name" (Elm.string addLevelKeepSiblingStackArg.name)
            , Tuple.pair
                "isAlias"
                (Elm.bool addLevelKeepSiblingStackArg.isAlias)
            ]
        , addLevelKeepSiblingStackArg0
        ]


{-| addFragment: { fragment : Can.Fragment, alongsideOtherFields : Bool } -> Cache -> Cache -}
addFragment :
    { fragment : Elm.Expression, alongsideOtherFields : Bool }
    -> Elm.Expression
    -> Elm.Expression
addFragment addFragmentArg addFragmentArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addFragment"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "fragment"
                              , Type.namedWith [ "Can" ] "Fragment" []
                              )
                            , ( "alongsideOtherFields", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair "fragment" addFragmentArg.fragment
            , Tuple.pair
                "alongsideOtherFields"
                (Elm.bool addFragmentArg.alongsideOtherFields)
            ]
        , addFragmentArg0
        ]


{-| addVars: List ( String, GraphQL.Schema.Type ) -> Cache -> Cache -}
addVars : List Elm.Expression -> Elm.Expression -> Elm.Expression
addVars addVarsArg addVarsArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addVars"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                )
                            )
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.list addVarsArg, addVarsArg0 ]


{-| finishedDefinition: Cache -> Cache -}
finishedDefinition : Elm.Expression -> Elm.Expression
finishedDefinition finishedDefinitionArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "finishedDefinition"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" [] ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ finishedDefinitionArg ]


{-| init: { reservedNames : List String } -> Cache -}
init : { reservedNames : List String } -> Elm.Expression
init initArg =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "init"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "reservedNames", Type.list Type.string ) ]
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
        )
        [ Elm.record
            [ Tuple.pair
                "reservedNames"
                (Elm.list (List.map Elm.string initArg.reservedNames))
            ]
        ]


annotation_ : { filePath : Type.Annotation, cache : Type.Annotation }
annotation_ =
    { filePath = Type.alias moduleName_ "FilePath" [] Type.string
    , cache =
        Type.alias
            moduleName_
            "Cache"
            []
            (Type.record
                [ ( "varTypes"
                  , Type.list
                        (Type.tuple
                            Type.string
                            (Type.namedWith [ "GraphQL", "Schema" ] "Type" [])
                        )
                  )
                , ( "fragmentsUsed"
                  , Type.list
                        (Type.record
                            [ ( "fragment"
                              , Type.namedWith [ "Can" ] "Fragment" []
                              )
                            , ( "alongsideOtherFields", Type.bool )
                            ]
                        )
                  )
                , ( "originalNames"
                  , Type.namedWith [ "UsedNames" ] "UsedNames" []
                  )
                , ( "usedNames", Type.namedWith [ "UsedNames" ] "UsedNames" [] )
                , ( "usage", Type.namedWith [ "Usage" ] "Usages" [] )
                ]
            )
    }


make_ :
    { cache :
        { varTypes : Elm.Expression
        , fragmentsUsed : Elm.Expression
        , originalNames : Elm.Expression
        , usedNames : Elm.Expression
        , usage : Elm.Expression
        }
        -> Elm.Expression
    }
make_ =
    { cache =
        \cache_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    "Cache"
                    []
                    (Type.record
                        [ ( "varTypes"
                          , Type.list
                                (Type.tuple
                                    Type.string
                                    (Type.namedWith
                                        [ "GraphQL", "Schema" ]
                                        "Type"
                                        []
                                    )
                                )
                          )
                        , ( "fragmentsUsed"
                          , Type.list
                                (Type.record
                                    [ ( "fragment"
                                      , Type.namedWith [ "Can" ] "Fragment" []
                                      )
                                    , ( "alongsideOtherFields", Type.bool )
                                    ]
                                )
                          )
                        , ( "originalNames"
                          , Type.namedWith [ "UsedNames" ] "UsedNames" []
                          )
                        , ( "usedNames"
                          , Type.namedWith [ "UsedNames" ] "UsedNames" []
                          )
                        , ( "usage", Type.namedWith [ "Usage" ] "Usages" [] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "varTypes" cache_args.varTypes
                    , Tuple.pair "fragmentsUsed" cache_args.fragmentsUsed
                    , Tuple.pair "originalNames" cache_args.originalNames
                    , Tuple.pair "usedNames" cache_args.usedNames
                    , Tuple.pair "usage" cache_args.usage
                    ]
                )
    }


call_ :
    { enum :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , scalar :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , field :
        Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
        -> Elm.Expression
    , subscription :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , mutation :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , query :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    , levelFromField : Elm.Expression -> Elm.Expression
    , siblingCollision : Elm.Expression -> Elm.Expression -> Elm.Expression
    , saveSibling : Elm.Expression -> Elm.Expression -> Elm.Expression
    , getGlobalName : Elm.Expression -> Elm.Expression -> Elm.Expression
    , dropLevelNotSiblings : Elm.Expression -> Elm.Expression
    , dropLevel : Elm.Expression -> Elm.Expression
    , addLevel : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addLevelKeepSiblingStack :
        Elm.Expression -> Elm.Expression -> Elm.Expression
    , addFragment : Elm.Expression -> Elm.Expression -> Elm.Expression
    , addVars : Elm.Expression -> Elm.Expression -> Elm.Expression
    , finishedDefinition : Elm.Expression -> Elm.Expression
    , init : Elm.Expression -> Elm.Expression
    }
call_ =
    { enum =
        \enumArg enumArg0 enumArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "enum"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ enumArg, enumArg0, enumArg1 ]
    , scalar =
        \scalarArg scalarArg0 scalarArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "scalar"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ scalarArg, scalarArg0, scalarArg1 ]
    , field =
        \fieldArg fieldArg0 fieldArg1 fieldArg2 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "field"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ fieldArg, fieldArg0, fieldArg1, fieldArg2 ]
    , subscription =
        \subscriptionArg subscriptionArg0 subscriptionArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "subscription"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ subscriptionArg, subscriptionArg0, subscriptionArg1 ]
    , mutation =
        \mutationArg mutationArg0 mutationArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "mutation"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ mutationArg, mutationArg0, mutationArg1 ]
    , query =
        \queryArg queryArg0 queryArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "query"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string
                                , Type.namedWith [] "FilePath" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ queryArg, queryArg0, queryArg1 ]
    , levelFromField =
        \levelFromFieldArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "levelFromField"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.extensible
                                    "field"
                                    [ ( "name"
                                      , Type.namedWith [ "AST" ] "Name" []
                                      )
                                    , ( "alias_"
                                      , Type.namedWith
                                            []
                                            "Maybe"
                                            [ Type.namedWith [ "AST" ] "Name" []
                                            ]
                                      )
                                    ]
                                ]
                                (Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                )
                            )
                    }
                )
                [ levelFromFieldArg ]
    , siblingCollision =
        \siblingCollisionArg siblingCollisionArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "siblingCollision"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "UsedNames" ] "Sibling" []
                                , Type.namedWith [] "Cache" []
                                ]
                                Type.bool
                            )
                    }
                )
                [ siblingCollisionArg, siblingCollisionArg0 ]
    , saveSibling =
        \saveSiblingArg saveSiblingArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "saveSibling"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [ "UsedNames" ] "Sibling" []
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ saveSiblingArg, saveSiblingArg0 ]
    , getGlobalName =
        \getGlobalNameArg getGlobalNameArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "getGlobalName"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string, Type.namedWith [] "Cache" [] ]
                                (Type.record
                                    [ ( "globalName", Type.string )
                                    , ( "used", Type.namedWith [] "Cache" [] )
                                    ]
                                )
                            )
                    }
                )
                [ getGlobalNameArg, getGlobalNameArg0 ]
    , dropLevelNotSiblings =
        \dropLevelNotSiblingsArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "dropLevelNotSiblings"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Cache" [] ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ dropLevelNotSiblingsArg ]
    , dropLevel =
        \dropLevelArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "dropLevel"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Cache" [] ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ dropLevelArg ]
    , addLevel =
        \addLevelArg addLevelArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addLevel"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addLevelArg, addLevelArg0 ]
    , addLevelKeepSiblingStack =
        \addLevelKeepSiblingStackArg addLevelKeepSiblingStackArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addLevelKeepSiblingStack"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "name", Type.string )
                                    , ( "isAlias", Type.bool )
                                    ]
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addLevelKeepSiblingStackArg, addLevelKeepSiblingStackArg0 ]
    , addFragment =
        \addFragmentArg addFragmentArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addFragment"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "fragment"
                                      , Type.namedWith [ "Can" ] "Fragment" []
                                      )
                                    , ( "alongsideOtherFields", Type.bool )
                                    ]
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addFragmentArg, addFragmentArg0 ]
    , addVars =
        \addVarsArg addVarsArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "addVars"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.list
                                    (Type.tuple
                                        Type.string
                                        (Type.namedWith
                                            [ "GraphQL", "Schema" ]
                                            "Type"
                                            []
                                        )
                                    )
                                , Type.namedWith [] "Cache" []
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ addVarsArg, addVarsArg0 ]
    , finishedDefinition =
        \finishedDefinitionArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "finishedDefinition"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith [] "Cache" [] ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ finishedDefinitionArg ]
    , init =
        \initArg ->
            Elm.apply
                (Elm.value
                    { importFrom =
                        [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
                    , name = "init"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.record
                                    [ ( "reservedNames", Type.list Type.string )
                                    ]
                                ]
                                (Type.namedWith [] "Cache" [])
                            )
                    }
                )
                [ initArg ]
    }


values_ :
    { enum : Elm.Expression
    , scalar : Elm.Expression
    , field : Elm.Expression
    , subscription : Elm.Expression
    , mutation : Elm.Expression
    , query : Elm.Expression
    , levelFromField : Elm.Expression
    , siblingCollision : Elm.Expression
    , saveSibling : Elm.Expression
    , getGlobalName : Elm.Expression
    , dropLevelNotSiblings : Elm.Expression
    , dropLevel : Elm.Expression
    , addLevel : Elm.Expression
    , addLevelKeepSiblingStack : Elm.Expression
    , addFragment : Elm.Expression
    , addVars : Elm.Expression
    , finishedDefinition : Elm.Expression
    , init : Elm.Expression
    }
values_ =
    { enum =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "enum"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , scalar =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "scalar"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , field =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "field"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , subscription =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "subscription"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , mutation =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "mutation"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , query =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "query"
            , annotation =
                Just
                    (Type.function
                        [ Type.string
                        , Type.namedWith [] "FilePath" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , levelFromField =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "levelFromField"
            , annotation =
                Just
                    (Type.function
                        [ Type.extensible
                            "field"
                            [ ( "name", Type.namedWith [ "AST" ] "Name" [] )
                            , ( "alias_"
                              , Type.namedWith
                                    []
                                    "Maybe"
                                    [ Type.namedWith [ "AST" ] "Name" [] ]
                              )
                            ]
                        ]
                        (Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        )
                    )
            }
    , siblingCollision =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "siblingCollision"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        Type.bool
                    )
            }
    , saveSibling =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "saveSibling"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "UsedNames" ] "Sibling" []
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , getGlobalName =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "getGlobalName"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.namedWith [] "Cache" [] ]
                        (Type.record
                            [ ( "globalName", Type.string )
                            , ( "used", Type.namedWith [] "Cache" [] )
                            ]
                        )
                    )
            }
    , dropLevelNotSiblings =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "dropLevelNotSiblings"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" [] ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , dropLevel =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "dropLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" [] ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addLevel =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevel"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addLevelKeepSiblingStack =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addLevelKeepSiblingStack"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "name", Type.string )
                            , ( "isAlias", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addFragment =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addFragment"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "fragment"
                              , Type.namedWith [ "Can" ] "Fragment" []
                              )
                            , ( "alongsideOtherFields", Type.bool )
                            ]
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , addVars =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "addVars"
            , annotation =
                Just
                    (Type.function
                        [ Type.list
                            (Type.tuple
                                Type.string
                                (Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Type"
                                    []
                                )
                            )
                        , Type.namedWith [] "Cache" []
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , finishedDefinition =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "finishedDefinition"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [] "Cache" [] ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    , init =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize", "Cache" ]
            , name = "init"
            , annotation =
                Just
                    (Type.function
                        [ Type.record
                            [ ( "reservedNames", Type.list Type.string ) ]
                        ]
                        (Type.namedWith [] "Cache" [])
                    )
            }
    }


