module codeWriter;
import std.stdio;
import std.file;
import std.path;
import std.array;
import std.conv;
import std.string;
public class CodeWriter{
    File output_file;
    this(string output){
        output_file = File(output,"w");
    }

    void writeArithmetic(string command){
        switch (command){
            case "add":
            case "sub":
            case "neg":
            case "eq":
            case "gt":
            case "lt":
            case "and":
            case "or":
            case "not":
            default:
        }
    }
    void writePushOrPop(string cType,string segment, int index){
        switch (cType){
            case "C_PUSH":
                switch (segment){
                    case "local":
                        output_file.write(
                            "//*************---push local command---************\n
                        @LCL\n
                        D = M\n
                        @"~to!string(index)~
                            "\nD = D + A
                        A = D\n
                        D = M\n
                        @SP\n
                        A = M\n
                        M = D\n
                        @SP\n
                        M = M + 1\n");
                        break;
                    case "argument":
                        output_file.write(
                            "*************---push argument command---************\n
                        @ARG\n
                         D = M
                         @"~to!string(index)~
                            "D = D + A
                         A = D\n
                         D = M\n
                         @SP\n
                         A = M\n
                         M = D\n
                         @SP\n
                         M = M + 1\n");
                        break;
                    case "this":
                        output_file.write(
                            "//*************---push this command---************\n
                        @THIS\n
                         D =\n/n
                         @"~to!string(index)~
                            "D = D + A
                         A = D\n
                         D = M\n
                         @SP\n
                         A = M\n
                         M = D\n
                         @SP\n
                         M = M + 1\n");
                        break;
                    case "constant":
                        output_file.write(
                            "//*************---push constant command---************\n
                        @"~to!string(index)~ "// D =index\n
                        D=A\n
                        // RAM[SP] =D\n
                        @SP\n
                        A=M\n
                        M=D\n
                        // SP++\n
                        @SP\n
                        M=M+1\n");
                        break;
                    case "static":
                        output_file.write(//not shure need to add 16
                            "//*************---push static command---************\n
                        @16\n
                         D = M\n
                         @"~to!string(index)~
                            "\nD = D + A\n
                         A = D\n
                         D = M\n
                         @SP\n
                         A = M\n
                         M = D\n
                         @SP\n
                         M = M + 1\n");
                        break;
                    case "pointer":
                        output_file.write(
                            "//*************---push pointer command---************\n
                        @THIS\n
                         D = A\n
                         @"~to!string(index)~
                            "\nD = D + A\n
                         A = D\n
                         D = M\n
                         @SP\n
                         A = M\n
                         M = D\n
                         @SP\n
                         M = M + 1\n");
                        break;
                    case "temp":
                        output_file.write(
                            "//*************---push temp command---************\n
                        @5\n
                        D = A\n
                        @"~to!string(index)~
                            "\nD = D +A\n
                        A = D\n
                        D = M\n
                        @SP\n
                        M = D\n");
                        break;
                    default:
                        output_file.write("//********PUSH ERROR********");

                }
                break;
            case "C_POP":
                switch (segment){
                    case "local":
                        output_file.write(
                            "//*************---pop local command---************\n
                        @LCL\n
                        D = M\n
                        @"~to!string(index)~
                            "\nD = D +A\n

                        @SP\n
                        M = M -1\n
                        E = M\n

                        A = D\n
                        M = E\n"
                        );
                        break;
                    case "argument":
                        output_file.write(
                            "//*************---pop argument command---************\n
                        @ARG\n
                        D = M\n
                        @"~to!string(index)~
                            "\nD = D +A\n

                        @SP\n
                        M = M -1\n
                        E = M\n

                        A = D\n
                        M = E\n"
                        );
                        break;
                    case "this":
                        output_file.write(
                            "//*************---pop this command---************\n
                        @THIS\n
                        D = M\n
                        @"~to!string(index)~
                            "\nD = D +A\n

                        @SP\n
                        M = M -1\n
                        E = M\n

                        A = D\n
                        M = E\n"
                        );
                        break;
                    case "static":
                    //not shure where static is
                        output_file.write(
                            "//*************---pop static command---************\n
                        @LCL\n
                        D = M\n
                        @"~to!string(index)~
                            "\nD = D +A\n

                        @SP\n
                        M = M -1\n
                        E = M\n

                        A = D\n
                        M = E\n"
                        );
                        break;
                    case "pointer":
                        output_file.write(
                            "//*************---pop pointer command---************\n
                        @THIS\n
                        D = A\n
                        @"~to!string(index)~
                            "\nD = D +A\n

                        @SP\n
                        M = M -1\n
                        E = M\n

                        A = D\n
                        A = M\n
                        M = E\n"
                        );
                        break;
                    case "temp":
                        output_file.write(
                            "//*************---pop temp command---************\n
                        //D = 5 + index\n
                        @5\n
                        D = A\n
                        @"~to!string(index)~
                            "\nD = D +A\n

                        //SP--\n
                        @SP\n
                        M = M -1\n
                        //E = top\n
                        E = M\n
                        //RAM[D] = E\n
                        A = D\n
                        M = E\n"
                        );
                        break;
                    default:
                        output_file.write( "//********POP ERROR********");
                        break;
                }
                break;
            default:
                output_file.write("//********SEGMENT ERROR********");
                break;
        }
    }
    void close(){
        output_file.close();
    }
}