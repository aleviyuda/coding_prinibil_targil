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
    string input = "C:\\nand2tetris\\projects\\08\\FunctionCalls\\FibonacciElement";
    //string input = readln();
    string [] splites = input.split("\\");
    string file_name = splites[splites.length-1];
    int count =0;
    CodeWriter coder = new CodeWriter(input ~ "\\" ~ file_name ~ ".asm");
    foreach (f_vm; dirEntries(input,"*.vm",SpanMode.shallow)){
        Parser parser  = new Parser(f_vm.name);
        //CodeWriter coder = new CodeWriter(input ~ "\\" ~ f_vm.baseName.split(".")[0] ~ ".asm");
        while(parser.HasMoreLines()){
            parser.next();
            switch (parser.commandType()){
                case "C_PUSH":
                case "C_POP":
                    coder.writePushOrPop(parser.commandType(), parser.arg1(), to!int(parser.arg2()),file_name);
                    break;
                case "C_ARITHMETIC":
                    coder.writeArithmetic(parser.current_command());
                    break;
                case "C_LABEL":
                    coder.writeLabel(parser.arg1(),file_name);
                    break;
                case "C_GOTO":
                    coder.writeGoto(parser.arg1(),file_name);
                    break;
                case "C_IF":
                    coder.CodeWriter.writeIF(parser.arg1(),file_name);
                    break;
                case "C_FUNCTION":
                    coder.writeFunction(parser.arg1(),to!int(parser.arg2()), file_name);
                    break;
                case "C_CALL":
                    coder.writeCall(parser.arg1(),to!int(parser.arg2()),file_name);
                    break;
                case "C_RETURN":
                    coder.writeReturn();
                    break;
                default:
                    break;

            }
        }
        count++;
        coder.writeEndFile(count);
        parser.close();
    }
    coder.close();
}
