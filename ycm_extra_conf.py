from distutils.sysconfig import get_python_inc
import os
import ycm_core

SOURCE_EXTENSIONS = [".cpp", ".cxx", ".cc", ".c", ".m", ".mm"]

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
flags = [
    "-Weverything",
    "-Wno-c++98-compat",
    "-Wno-c++98-compat-pedantic",
    "-Wno-weak-vtables",
    "-Wno-disabled-macro-expansion",
    "-Wno-reserved-id-macro",
    "-Wno-global-constructors",
    "-Wno-exit-time-destructors",
    "-Wno-double-promotion",
    "-Wno-padded",
    "-Wno-gnu-zero-variadic-macro-arguments",
    "-Wno-ctad-maybe-unsupported",
    # THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
    # use when compiling headers. So it will guess. Badly. So C++ headers will be
    # compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
    # For a C project, you would set this to 'c' instead of 'c++'.
    "-x",
    "c++",
    "-std=c++2a",
    "-isystem",
    get_python_inc(),
]


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = ""

if os.path.exists(compilation_database_folder):
    database = ycm_core.CompilationDatabase(compilation_database_folder)
else:
    database = None


def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in [".h", ".hxx", ".hpp", ".hh"]


def FindCorrespondingSourceFile(filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                return replacement_file
    return filename


def Settings(**kwargs):
    if kwargs["language"] == "cfamily":
        # If the file is a header, try to find the corresponding source file and
        # retrieve its flags from the compilation database if using one. This is
        # necessary since compilation databases don't have entries for header files.
        # In addition, use this source file as the translation unit. This makes it
        # possible to jump from a declaration in the header file to its definition
        # in the corresponding source file.
        filename = FindCorrespondingSourceFile(kwargs["filename"])

        if not database:
            return {
                "flags": flags,
                "override_filename": filename,
            }

        compilation_info = database.GetCompilationInfoForFile(filename)
        if not compilation_info.compiler_flags_:
            return {}

        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object.
        final_flags = list(compilation_info.compiler_flags_)

        return {
            "flags": final_flags,
            "include_paths_relative_to_dir": compilation_info.compiler_working_dir_,
            "override_filename": filename,
        }
    return {}


def GetStandardLibraryIndexInSysPath(sys_path):
    for path in sys_path:
        if os.path.isfile(os.path.join(path, "os.py")):
            return sys_path.index(path)
    raise RuntimeError("Could not find standard library path in Python path.")


def PythonSysPath(**kwargs):
    sys_path = kwargs["sys_path"]
    return sys_path
