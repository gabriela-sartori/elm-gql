"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = (function () { return "module GraphQL.Mock exposing (Schema, mock, schemaFromString)\n\n{-| -}\n\nimport GraphQL.Engine exposing (..)\nimport GraphQL.Operations.Canonicalize as Canonicalize\nimport GraphQL.Operations.Mock as Mock\nimport GraphQL.Operations.Parse as Parse\nimport GraphQL.Schema\nimport Json.Decode\nimport Json.Encode\n\n\n{-| -}\ntype Schema\n    = Schema String\n\n\ntype alias Error =\n    { title : String\n    , description : String\n    }\n\n\n{-| -}\nschemaFromString : String -> Schema\nschemaFromString =\n    Schema\n\n\n{-| Given a premade query or mutation, return an auto-mocked, json-stringified version of what the query is expecting\n-}\nmock : Schema -> Selection Query value -> Result Error String\nmock (Schema schemaStr) q =\n    case Json.Decode.decodeString GraphQL.Schema.decoder schemaStr of\n        Ok schema ->\n            -- case Parse.parse (GraphQL.Engine.getGql premade) of\n            --     Err err ->\n            --         Err\n            --             { title = \"Malformed query\"\n            --             , description =\n            --                 Parse.errorToString err\n            --             }\n            --     Ok query ->\n            --         case Canonicalize.canonicalize schema query of\n            --             Err errors ->\n            --                 Err\n            --                     { title = \"Errors\"\n            --                     , description =\n            --                         List.map Canonicalize.errorToString errors\n            --                             |> String.join \"\\n\\n    \"\n            --                     }\n            --             Ok canAST ->\n            --                 case Mock.generate canAST of\n            --                     Ok [] ->\n            --                         Err\n            --                             { title = \"No named queries present\"\n            --                             , description =\n            --                                 \"Can't generate data if there are no queries\"\n            --                             }\n            --                     Ok (op :: _) ->\n            --                         -- this throws away everything but the first named operation\n            --                         -- But ultimately there should be only one named operation\n            --                         Ok\n            --                             (op.body\n            --                                 |> Json.Encode.encode 4\n            --                             )\n            --                     Err mockError ->\n            --                         Err\n            --                             { title = \"Errors\"\n            --                             , description =\n            --                                 \"Issue generating mocked data\"\n            --                             }\n            Err\n                { title = \"Mock is not implemented!\"\n                , description =\n                    \"Rerun elm-gql\"\n                }\n\n        Err errors ->\n            Err\n                { title = \"Error decoding schema\"\n                , description =\n                    \"Rerun elm-gql\"\n                }\n"; });
