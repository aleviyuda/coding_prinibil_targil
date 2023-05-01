module main;
import codeWriter;
import parser;
import std.stdio;
import std.file;
import std.path;
import std.array;
import std.conv;
import std.string;
void main()
{
    writeln("Enter path of input folder");
    string input = "C:\\D\\nand2tetris\\projects\\07\\StackArithmetic\\StackTest";
    //string input = readln();
    foreach (f_vm; dirEntries(input,"*.vm",SpanMode.shallow)){
        Parser parser  = new Parser(f_vm.name);
        CodeWriter coder = new CodeWriter(input ~ ".asm");
        while(parser.HasMoreLines()){
            parser.next();
            switch (parser.commandType()){
                case "C_PUSH":
                case "C_POP":
                    string [] splites = input.split("\\");
                    coder.writePushOrPop(parser.commandType(), parser.arg1(), to!int(parser.arg2()),splites[splites.length-1]);
                    break;
                case "C_ARITHMETIC":
                    coder.writeArithmetic(parser.current_command());
                    break;
                default:
                    break;
            }
        }
        parser.close();
        coder.close();
    }
}
