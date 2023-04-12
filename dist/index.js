"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var commander = __importStar(require("commander"));
var fs = __importStar(require("fs"));
var path = __importStar(require("path"));
var crypto = __importStar(require("crypto"));
var chalk_1 = __importDefault(require("chalk"));
var XMLHttpRequest_1 = require("./vendor/XMLHttpRequest");
var schema_generator = require("./generators/schema");
var Engine_elm_1 = __importDefault(require("./templates/Engine.elm"));
var Mock_elm_1 = __importDefault(require("./templates/Mock.elm"));
var Schema_elm_1 = __importDefault(require("./templates/Schema.elm"));
var AST_elm_1 = __importDefault(require("./templates/Operations/AST.elm"));
var Mock_elm_2 = __importDefault(require("./templates/Operations/Mock.elm"));
var CanonicalAST_elm_1 = __importDefault(require("./templates/Operations/CanonicalAST.elm"));
var Parse_elm_1 = __importDefault(require("./templates/Operations/Parse.elm"));
var Canonicalize_elm_1 = __importDefault(require("./templates/Operations/Canonicalize.elm"));
// We have to stub this in the allow Elm the ability to make http requests.
// @ts-ignore
globalThis["XMLHttpRequest"] = XMLHttpRequest_1.XMLHttpRequest.XMLHttpRequest;
var version = "0.1.0";
function emptyCache(namespace) {
    var emptyFiles = {};
    emptyFiles[namespace] = {};
    return {
        engineVersion: version,
        files: emptyFiles,
    };
}
// Run a standard generator made by elm-prefab
function run_generator(generator, flags) {
    return __awaiter(this, void 0, void 0, function () {
        var promise;
        return __generator(this, function (_a) {
            promise = new Promise(function (resolve, reject) {
                // @ts-ignore
                var app = generator.init({ flags: flags });
                if (app.ports.onSuccessSend) {
                    app.ports.onSuccessSend.subscribe(resolve);
                }
                if (app.ports.onInfoSend) {
                    app.ports.onInfoSend.subscribe(function (info) { return console.log(info); });
                }
                if (app.ports.onFailureSend) {
                    app.ports.onFailureSend.subscribe(reject);
                }
            })
                .then(function (files) {
                // clear generated queries/mutations
                // because now we're confident we can replace them.
                for (var _i = 0, _a = flags.gql; _i < _a.length; _i++) {
                    var file = _a[_i];
                    var targetDir = file.path.replace(".gql", "").replace(".graphql", "");
                    clearDir(targetDir);
                    clearDir(path.join(targetDir, "Fragments"));
                }
                var files_written_count = 0;
                var files_skipped = 0;
                for (var _b = 0, files_1 = files; _b < files_1.length; _b++) {
                    var file = files_1[_b];
                    fs.mkdirSync(path.dirname(file.path), { recursive: true });
                    if (writeIfChanged(file.path, file.contents)) {
                        files_written_count = files_written_count + 1;
                    }
                    else {
                        files_skipped = files_skipped + 1;
                    }
                }
                if (flags.init) {
                    initGreeting(files_written_count + files_skipped, flags);
                }
                else if (flags.force) {
                    forceMessage(files_written_count, files_skipped, flags);
                }
                else {
                    var lines = [];
                    if (files_written_count > 0) {
                        var modifiedFileNames = "";
                        if (flags.generatePlatform) {
                            modifiedFileNames = "The " + chalk_1.default.cyan(flags.namespace + " schema") + " has changed, ";
                        }
                        else if (flags.gql.length == 1) {
                            modifiedFileNames = chalk_1.default.cyan(flags.gql[0].path) + " was modified, ";
                        }
                        else {
                            modifiedFileNames = flags.gql.length + " GQL files were modified, ";
                        }
                        if (files_written_count == 1) {
                            lines.push("" + modifiedFileNames + chalk_1.default.yellow(files_written_count) + " file generated!");
                        }
                        else {
                            lines.push("" + modifiedFileNames + chalk_1.default.yellow(files_written_count) + " files generated!");
                        }
                    }
                    if (files_skipped > 0) {
                        if (files_skipped == 1) {
                            lines.push(chalk_1.default.gray(files_skipped) + " file skipped because it was already present and up-to-date");
                        }
                        else {
                            lines.push(chalk_1.default.gray(files_skipped) + " files skipped because they were already present and up-to-date");
                        }
                    }
                    console.log(format_block(lines));
                }
            })
                .catch(function (errorList) {
                for (var _i = 0, errorList_1 = errorList; _i < errorList_1.length; _i++) {
                    var error = errorList_1[_i];
                    console.error(format_title(error.title), "\n\n" + error.description + "\n");
                }
                process.exit(1);
            });
            return [2 /*return*/, promise];
        });
    });
}
/* Get files recursively */
var isDirectory = function (pathStr) { return fs.statSync(pathStr).isDirectory(); };
var getDirectories = function (pathStr) {
    return fs
        .readdirSync(pathStr)
        .map(function (name) { return path.join(pathStr, name); })
        .filter(isDirectory);
};
var isFile = function (filepath) {
    return fs.statSync(filepath).isFile() &&
        (filepath.endsWith(".gql") || filepath.endsWith(".graphql"));
};
var getFiles = function (filepath) {
    return fs
        .readdirSync(filepath)
        .map(function (name) { return path.join(filepath, name); })
        .filter(isFile);
};
var getFilesRecursively = function (filepath) {
    var dirs = getDirectories(filepath);
    var files = dirs
        .map(function (dir) { return getFilesRecursively(dir); }) // go through each directory
        .reduce(function (a, b) { return a.concat(b); }, []); // map returns a 2d array (array of file arrays) so flatten
    return files.concat(getFiles(filepath));
};
/* CLI feedback formatting */
function format_title(title) {
    var tail = "-".repeat(80 - (title.length + 2));
    return chalk_1.default.cyan("--" + title + tail);
}
function format_block(content) {
    return "\n    " + content.join("\n    ") + "\n";
}
function format_bullet(content) {
    return "  \u2022 " + content;
}
function writeIfChanged(filepath, content) {
    try {
        var foundContents = fs.readFileSync(filepath);
        var foundHash = crypto
            .createHash("md5")
            .update(foundContents)
            .digest("hex");
        var desiredHash = crypto.createHash("md5").update(content).digest("hex");
        if (foundHash != desiredHash) {
            fs.writeFileSync(filepath, content);
            return true;
        }
        return false;
    }
    catch (_a) {
        fs.writeFileSync(filepath, content);
        return true;
    }
}
var wasModified = function (namespace, cache, file) {
    var stat = fs.statSync(file);
    if (namespace in cache.files) {
        if (file in cache.files[namespace]) {
            if (+cache.files[namespace][file].modified == +stat.mtime) {
                return { at: stat.mtime, was: false };
            }
            else {
                return { at: stat.mtime, was: true };
            }
        }
        else {
            return { at: stat.mtime, was: true };
        }
    }
    else {
        return { at: stat.mtime, was: true };
    }
};
var readCache = function (namespace, force) {
    var cache = emptyCache(namespace);
    if (force) {
        return cache;
    }
    try {
        cache = JSON.parse(fs.readFileSync(".elm-gql-cache").toString());
        if (namespace in cache.files) {
            for (var path_1 in cache.files[namespace]) {
                cache.files[namespace][path_1] = {
                    modified: new Date(cache.files[namespace][path_1].modified),
                };
            }
        }
        else {
            return emptyCache(namespace);
        }
    }
    catch (_a) { }
    return cache;
};
var cacheExists = function (namespace) {
    try {
        return fs.existsSync(".elm-gql-cache");
    }
    catch (_a) { }
    return false;
};
var clearDir = function (dir) {
    try {
        var files = fs.readdirSync(dir);
        for (var _i = 0, files_2 = files; _i < files_2.length; _i++) {
            var file = files_2[_i];
            fs.unlinkSync(path.join(dir, file));
        }
    }
    catch (_a) { }
};
function initGreeting(filesGenerated, flags) {
    var lines = [];
    lines.push("Welcome to " + chalk_1.default.cyan("elm-gql") + "!");
    lines.push("I've generated a number of files to get you started:");
    lines.push("");
    lines.push(format_bullet("" + chalk_1.default.cyan("src/" + flags.namespace + ".elm")));
    lines.push(format_bullet(chalk_1.default.yellow(filesGenerated) + " files in " + chalk_1.default.cyan(flags.elmBaseSchema.join("/") + "/")));
    if (flags.gql.length == 1) {
        lines.push(format_bullet("I also found " + chalk_1.default.yellow(flags.gql.length) + " GQL file and generated Elm code to help you use it."));
    }
    else if (flags.gql.length > 0) {
        lines.push(format_bullet("I also found " + chalk_1.default.yellow(flags.gql.length) + " GQL files and generated Elm code to help you use them."));
    }
    lines.push(format_bullet("I've saved the schema as " + chalk_1.default.cyan(flags.namespace + "/schema.json")));
    lines.push("");
    lines.push("Learn more about writing a query to get started!");
    lines.push(chalk_1.default.yellow("https://github.com/vendrinc/elm-gql/blob/main/guide/LifeOfAQuery.md"));
    console.log(format_block(lines));
}
function initOverwriteWarning() {
    var lines = [];
    lines.push("I tried to run " + chalk_1.default.yellow("elm-gql init") + ", but it looks like elm-gql has already been init-ed.");
    lines.push("If you're sure you want to rerun " + chalk_1.default.cyan("init") + ", pass " + chalk_1.default.yellow("--force"));
    console.log(format_block(lines));
}
function forceMessage(filesGenerated, files_skipped, flags) {
    var lines = [];
    lines.push(chalk_1.default.cyan("elm-gql") + chalk_1.default.yellow(" --force") + " was used, all files are being regenerated.");
    lines.push("");
    lines.push(chalk_1.default.yellow(filesGenerated + files_skipped) + " files in " + chalk_1.default.cyan(flags.elmBaseSchema.join("/") + "/") + " were recreated");
    if (flags.gql.length == 1) {
        lines.push(chalk_1.default.yellow(flags.gql.length) + " GQL file was found and processed.");
    }
    else if (flags.gql.length > 0) {
        lines.push(chalk_1.default.yellow(flags.gql.length) + " GQL files were found and processed.");
    }
    lines.push("");
    lines.push("If you find yourself using " + chalk_1.default.yellow("--force") + " all the time, check to make sure it's actaully needed.");
    lines.push("Running without it will be much faster!");
    console.log(format_block(lines));
}
function run(schema, options) {
    return __awaiter(this, void 0, void 0, function () {
        var newCache, cache, schemaWasModified, gql_filepaths, fileSources, _i, gql_filepaths_1, file, modified, src;
        return __generator(this, function (_a) {
            newCache = emptyCache(options.namespace);
            cache = readCache(options.namespace, options.force);
            schemaWasModified = { at: new Date(), was: false };
            if (!schema.startsWith("http") && schema.endsWith("json")) {
                schemaWasModified = wasModified(options.namespace, cache, schema);
                newCache.files[options.namespace][schema] = {
                    modified: schemaWasModified.at,
                };
                schema = JSON.parse(fs.readFileSync(schema).toString());
            }
            gql_filepaths = getFilesRecursively(options.queries);
            fileSources = [];
            for (_i = 0, gql_filepaths_1 = gql_filepaths; _i < gql_filepaths_1.length; _i++) {
                file = gql_filepaths_1[_i];
                modified = wasModified(options.namespace, cache, file);
                if (modified.was || options.force) {
                    src = fs.readFileSync(file).toString();
                    fileSources.push({ src: src, path: file });
                }
                newCache.files[options.namespace][file] = { modified: modified.at };
            }
            if (fileSources.length > 0 || schemaWasModified.was || options.force) {
                run_generator(schema_generator.Elm.Generate, {
                    namespace: options.namespace,
                    // @ts-ignore
                    gql: fileSources,
                    header: options.header,
                    gqlDir: options.queries.split(path.sep),
                    elmBaseSchema: options.output.split(path.sep),
                    schema: schema,
                    generatePlatform: schemaWasModified.was || options.force,
                    force: options.force,
                    init: options.init,
                    existingEnumDefinitions: options.existingEnumDefinitions,
                });
            }
            else {
                console.log(format_block([
                    chalk_1.default.cyan("elm-gql: ") + " No files were modified, skipping codegen.",
                ]));
            }
            // Copy gql engine to target dir
            fs.mkdirSync(path.join(options.output, "GraphQL"), {
                recursive: true,
            });
            // Standard engine
            writeIfChanged(path.join(options.output, "GraphQL", "Engine.elm"), (0, Engine_elm_1.default)());
            // When mocking becomes a thing again, we'll turn this on
            // write_mock(options)
            fs.writeFileSync(".elm-gql-cache", JSON.stringify(newCache));
            return [2 /*return*/];
        });
    });
}
function write_mock(options) {
    fs.mkdirSync(path.join(options.output, "GraphQL", "Operations"), {
        recursive: true,
    });
    var ops = path.join(options.output, "GraphQL", "Operations");
    writeIfChanged(path.join(ops, "Mock.elm"), (0, Mock_elm_2.default)());
    writeIfChanged(path.join(ops, "AST.elm"), (0, AST_elm_1.default)());
    writeIfChanged(path.join(ops, "Parse.elm"), (0, Parse_elm_1.default)());
    writeIfChanged(path.join(ops, "CanonicalAST.elm"), (0, CanonicalAST_elm_1.default)());
    writeIfChanged(path.join(ops, "Canonicalize.elm"), (0, Canonicalize_elm_1.default)());
    // Everything required for auto-mocking
    writeIfChanged(path.join(options.output, "GraphQL", "Mock.elm"), (0, Mock_elm_1.default)());
    writeIfChanged(path.join(options.output, "GraphQL", "Schema.elm"), (0, Schema_elm_1.default)());
}
function checkNamespace(options) {
    // Namespace must match a single Elm module name
    //(Below is a NOT check (I always miss the !)
    if (!/^[A-Z][a-zA-Z]+$/.test(options.namespace)) {
        var lines = [];
        lines.push("The namespace you provided(" + chalk_1.default.yellow(options.namespace) + ") doesn't quite work unfortunately.");
        lines.push("A namespace can only be a single capitalized word like " + chalk_1.default.cyan("Api") + " or " + chalk_1.default.cyan("Gql") + " and it can't contain any periods or slashes!");
        console.log(format_block(lines));
        process.exit(1);
    }
}
function action(schema, options) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            options.init = false;
            checkNamespace(options);
            run(schema, options);
            return [2 /*return*/];
        });
    });
}
function init(schema, options) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            options.init = true;
            checkNamespace(options);
            if (!options.force && cacheExists(options.namespace)) {
                initOverwriteWarning();
                process.exit(1);
            }
            options.force = true;
            run(schema, options);
            return [2 /*return*/];
        });
    });
}
function collect(val, memo) {
    memo.push(val);
    return memo;
}
var program = new commander.Command();
var helpText = "\nWelcome to " + chalk_1.default.cyan("elm-gql") + "!\n\nMake sure to check out the " + chalk_1.default.yellow("guides") + ":\n    https://github.com/vendrinc/elm-gql\n";
program.version(version).name("elm-gql").addHelpText("before", helpText);
program
    .command("run")
    .description("\n    Generate Elm code from a GraphQL schema and " + chalk_1.default.yellow(".graphql") + " files.\n    This will create a " + chalk_1.default.yellow("codegen") + " directory and provide you with everything you need to get started.\n")
    .argument("<schema>", "The schema.")
    .option("--namespace <namespace>", "Use a namespace for the generated code.  It must be a capitalized word with no periods or spaces.", "Api")
    .option("--force", "Skip the cache.", false)
    .option("--header <header>", "The header to include in the introspection query.", collect, [])
    .option("--queries <dir>", "The directory to scan for GraphQL queries and mutations.", "src")
    .option("--output <dir>", "The directory where your generated files should go.", "api")
    .option("--existing-enum-definitions <name>", "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums.")
    .action(action);
program
    .command("init")
    .description("\n    Start an Elm GQL project.\n    \n    This will generate Elm code from a GraphQL schema and " + chalk_1.default.yellow(".graphql") + " files.\n    It's nearly the same as 'run', but will generate a file for handling your Scalars as well.\n")
    .argument("<schema>", "The schema.")
    .option("--namespace <namespace>", "Use a namespace for the generated code.  It must be a capitalized word with no periods or spaces.", "Api")
    .option("--force", "Skip the cache.", false)
    .option("-h, --header <header>", "The header to include in the introspection query.", collect, [])
    .option("--queries <dir>", "The directory to scan for GraphQL queries and mutations.", "src")
    .option("--output <dir>", "The directory where your generated files should go.", "api")
    .option("--existing-enum-definitions <name>", "This option isn't used very commonly.  If you already have Enum definitions generated, this will skip Enum generation and point to your existing enums.")
    .action(init);
program.showHelpAfterError();
program.parseAsync(process.argv);
