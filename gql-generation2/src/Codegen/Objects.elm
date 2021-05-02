module Codegen.Objects exposing (generateFiles)

import Codegen.Common as Common
import Dict
import Elm.CodeGen as Elm
import GraphQL.Schema
import GraphQL.Schema.Argument exposing (Argument)
import GraphQL.Schema.Type exposing (Type(..))
import String.Extra as String


generateFiles graphQLSchema =
    graphQLSchema.objects
        -- type alias Object =
        -- { name : String
        -- , description : Maybe String
        -- , fields : List Field
        -- , interfaces : List Kind
        -- }
        |> Dict.toList
        |> List.map
            (\( _, object ) ->
                let
                    moduleName =
                        [ "TnGql", "Object", object.name ]

                    module_ =
                        Elm.normalModule moduleName []

                    docs =
                        Nothing

                    fieldDecl =
                        object.fields
                            |> List.map
                                (\field ->
                                    let
                                        typeAnnotation =
                                            Common.gqlTypeToElmTypeAnnotation field.type_ Nothing

                                        -- { id = GraphQL.Engine.field identity "id" (Codec.decoder Scalar.codecs.id) {} []
                                        -- , name =
                                        --     \selection_ ->
                                        --         GraphQL.Engine.field identity "name" (GraphQL.Engine.decoder selection_) {} []
                                        -- , role = GraphQL.Engine.field identity "role" role {} []
                                        -- , email = GraphQL.Engine.field Json.maybe "email" (Codec.decoder Scalar.codecs.string) {} []
                                        -- , friends =
                                        --     \selection_ opts_ ->
                                        --         GraphQL.Engine.field Json.list "friends" (GraphQL.Engine.decoder selection_) {} opts_
                                        -- }
                                        implementation =
                                            case field.type_ of
                                                GraphQL.Schema.Type.Scalar scalarName ->
                                                    Elm.apply
                                                        [ Common.modules.engine.fns.field
                                                        , Elm.fun "identity"
                                                        , Elm.string field.name
                                                        , Elm.parens
                                                            (Elm.apply
                                                                [ Common.modules.codec.fns.decoder
                                                                , Elm.fqFun Common.modules.scalar.codecs.fqName (String.decapitalize scalarName)
                                                                ]
                                                            )
                                                        , Elm.record []
                                                        , Elm.list []
                                                        ]

                                                _ ->
                                                    Elm.string "unimplemented"
                                    in
                                    ( field.name, typeAnnotation, implementation )
                                )

                    -- GQL.Query (Maybe value)
                    objectTypeAnnotation =
                        fieldDecl
                            |> List.map (\( name, typeAnnotation, _ ) -> ( name, typeAnnotation ))
                            |> Elm.recordAnn

                    objectImplementation =
                        fieldDecl
                            |> List.map (\( name, _, implementation ) -> ( name, implementation ))
                            |> Elm.record

                    objectDecl =
                        Elm.valDecl Nothing (Just objectTypeAnnotation) (String.decapitalize object.name) objectImplementation
                in
                { name = moduleName
                , file =
                    Elm.file module_
                        [ Common.modules.decode.import_
                        ]
                        [ objectDecl ]
                        Nothing
                }
            )
