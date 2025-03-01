module Generate.Path exposing (Paths, fragment, operation)

import Utils.String


isDot : String -> Bool
isDot str =
    str == "."


fragment :
    { name : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    -> Paths
fragment { name, path, gqlDir } =
    let
        fragName =
            Utils.String.formatTypename name

        -- The path between elm root and the gql file
        pathFromElmRootToGqlFile =
            path
                |> String.split "/"
                |> List.map
                    (String.replace ".gql" ""
                        >> String.replace ".graphql" ""
                    )
                |> removePrefix (List.filter (not << isDot) gqlDir)
                |> List.map Utils.String.formatTypename

        filePathPieces =
            gqlDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Fragments", fragName ]

        mockFilePathPieces =
            gqlDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Mock", "Fragments", fragName ]
    in
    { modulePath = pathFromElmRootToGqlFile ++ [ "Fragments", fragName ]
    , mockModulePath = pathFromElmRootToGqlFile ++ [ "Mock", "Fragments", fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    , mockModuleFilePath =
        String.join "/" mockFilePathPieces ++ ".elm"
    }


type alias Paths =
    { modulePath : List String
    , mockModulePath : List String
    , filePath : String
    , mockModuleFilePath : String
    }


operation :
    { name : String

    -- all the dirs between CWD and the GQL file
    , path : String

    -- all the directories between CWD and the Elm root
    , gqlDir : List String
    }
    ->
        { modulePath : List String
        , mockModulePath : List String
        , filePath : String
        , mockModuleFilePath : String
        }
operation { name, path, gqlDir } =
    let
        fragName =
            Utils.String.formatTypename name

        -- The path between elm root and the gql file
        pathFromElmRootToGqlFile =
            path
                |> String.split "/"
                |> List.map
                    (String.replace ".gql" ""
                        >> String.replace ".graphql" ""
                    )
                |> removePrefix (List.filter (not << isDot) gqlDir)
                |> List.map Utils.String.formatTypename

        filePathPieces =
            gqlDir
                ++ pathFromElmRootToGqlFile
                ++ [ fragName ]

        mockFilePathPieces =
            gqlDir
                ++ pathFromElmRootToGqlFile
                ++ [ "Mock", fragName ]
    in
    { modulePath = pathFromElmRootToGqlFile ++ [ fragName ]
    , mockModulePath = pathFromElmRootToGqlFile ++ [ "Mock", fragName ]
    , filePath =
        String.join "/" filePathPieces ++ ".elm"
    , mockModuleFilePath =
        String.join "/" mockFilePathPieces ++ ".elm"
    }


removePrefix prefix list =
    case prefix of
        [] ->
            list

        _ :: remainPref ->
            case list of
                [] ->
                    list

                _ :: remain ->
                    removePrefix remainPref remain
