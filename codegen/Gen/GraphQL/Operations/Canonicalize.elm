module Gen.GraphQL.Operations.Canonicalize exposing (annotation_, call_, canonicalize, make_, moduleName_, values_)

{-| 
@docs values_, call_, make_, annotation_, canonicalize, moduleName_
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "GraphQL", "Operations", "Canonicalize" ]


{-| canonicalize: 
    GraphQL.Schema.Schema
    -> Paths
    -> AST.Document
    -> Result (List Error.Error) Can.Document
-}
canonicalize :
    Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
canonicalize canonicalizeArg canonicalizeArg0 canonicalizeArg1 =
    Elm.apply
        (Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Paths" []
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [ "Error" ] "Error" [])
                            , Type.namedWith [ "Can" ] "Document" []
                            ]
                        )
                    )
            }
        )
        [ canonicalizeArg, canonicalizeArg0, canonicalizeArg1 ]


annotation_ : { paths : Type.Annotation }
annotation_ =
    { paths =
        Type.alias
            moduleName_
            "Paths"
            []
            (Type.record
                [ ( "path", Type.string ), ( "gqlDir", Type.list Type.string ) ]
            )
    }


make_ :
    { paths :
        { path : Elm.Expression, gqlDir : Elm.Expression } -> Elm.Expression
    }
make_ =
    { paths =
        \paths_args ->
            Elm.withType
                (Type.alias
                    [ "GraphQL", "Operations", "Canonicalize" ]
                    "Paths"
                    []
                    (Type.record
                        [ ( "path", Type.string )
                        , ( "gqlDir", Type.list Type.string )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "path" paths_args.path
                    , Tuple.pair "gqlDir" paths_args.gqlDir
                    ]
                )
    }


call_ :
    { canonicalize :
        Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
    }
call_ =
    { canonicalize =
        \canonicalizeArg canonicalizeArg0 canonicalizeArg1 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
                    , name = "canonicalize"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.namedWith
                                    [ "GraphQL", "Schema" ]
                                    "Schema"
                                    []
                                , Type.namedWith [] "Paths" []
                                , Type.namedWith [ "AST" ] "Document" []
                                ]
                                (Type.namedWith
                                    []
                                    "Result"
                                    [ Type.list
                                        (Type.namedWith [ "Error" ] "Error" [])
                                    , Type.namedWith [ "Can" ] "Document" []
                                    ]
                                )
                            )
                    }
                )
                [ canonicalizeArg, canonicalizeArg0, canonicalizeArg1 ]
    }


values_ : { canonicalize : Elm.Expression }
values_ =
    { canonicalize =
        Elm.value
            { importFrom = [ "GraphQL", "Operations", "Canonicalize" ]
            , name = "canonicalize"
            , annotation =
                Just
                    (Type.function
                        [ Type.namedWith [ "GraphQL", "Schema" ] "Schema" []
                        , Type.namedWith [] "Paths" []
                        , Type.namedWith [ "AST" ] "Document" []
                        ]
                        (Type.namedWith
                            []
                            "Result"
                            [ Type.list (Type.namedWith [ "Error" ] "Error" [])
                            , Type.namedWith [ "Can" ] "Document" []
                            ]
                        )
                    )
            }
    }


