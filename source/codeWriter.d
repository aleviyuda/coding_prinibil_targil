module codeWriter;
import std.stdio;
import std.file;
import std.path;
import std.array;
import std.conv;
import std.string;
public class CodeWriter{
    File output_file;
    private int Eq_count = 0;
    this(string output){
        output_file = File(output,"w");
    }
    void writeLabel(string label){

    }

    void writeArithmetic(string command){
        switch (command){
            case "add":
                output_file.write(
                 "//*************---add command---************\n
                @SP\n
	            A = M - 1\n
	            D = M-1\n
	            A = A - 1\n
	            M = M + D\n
	            @SP\n
	            M = M - 1\n
                ");
                break;
            case "sub":
                output_file.write(
                 "//*************---sub command---************\n
                @SP\n
	            A = M - 1\n
	            D = M-1\n
	            A = A - 1\n
	            M = M - D\n
	            @SP\n
	            M = M - 1\n");
                break;
            case "neg":
                output_file.write(
                    "//*************---neg command---************\n
                @SP\n
	            A = M - 1\n
	            M = -M\n
                ");
                break;
            case "eq":
                Eq_count += 1;
                output_file.write(
                    "//*************---eq command---************\n
                	@SP\n
	                A=M-1\n
	                D=M\n
	                A=A-1\n
	                D=D-M\n
	                @IF_TRUE"~to!string(Eq_count)~
	                "\n D;JEQ\n
	                D=0\n
	                @SP\n
	                A=M-1\n
	                A=A-1\n
	                M=D\n
	                @IF_FALSE"~to!string(Eq_count)~
	                "\n 0;JMP\n
	                (@IF_TRUE"~to!string(Eq_count)~")\n
	                D=-1\n
	                @SP\n
	                A=M-1\n
	                A=A-1\n
	                M=D\n
	                (@IF_FALSE"~to!string(Eq_count)~")\n
	                @SP\n
	                M=M-1\n");
                break;
            case "gt":
                Eq_count += 1;
                output_file.write(
                    "//*************---gt command---************\n
                @SP\n
	            A=M-1\n
	            D=M\n
	            A=A-1\n
	            D=M-D\n
	            @IF_TRUE"~to!string(Eq_count)~
	            "\nD;JGT\n
	            D=0\n
	            @SP\n
	            A=M-1\n
	            A=A-1\n
	            M=D\n
	            @IF_FALSE"~to!string(Eq_count)~
	            "\n0;JMP\n
	            (@IF_TRUE"~to!string(Eq_count)~")\n
	            D=-1\n
	            @SP\n
	            A=M-1\n
	            A=A-1\n
	            M=D\n
	            (@IF_FALSE"~to!string(Eq_count)~")\n
	            @SP\n
	            M=M-1\n");
                break;
            case "lt":
                Eq_count += 1;
                output_file.write(
                    "//*************---lt command---************\n
                    @SP\n
	                A=M-1\n
	                D=M\n
	                A=A-1\n
	                D=M-D\n
	                @IF_TRUE"~to!string(Eq_count)~
	                "\nD;JLT\n
	                D=0\n
	                @SP\n
	                A=M-1\n
	                A=A-1\n
	                M=D\n
	                @IF_FALSE"~to!string(Eq_count)~
	                "\n0;JMP\n
	                (@IF_TRUE"~to!string(Eq_count)~")\n
	                D=-1\n
	                @SP\n
	                A=M-1\n
	                A=A-1\n
	                M=D\n
	                (@IF_FALSE"~to!string(Eq_count)~")\n
	                @SP\n
	                M=M-1\n");
                break;
            case "and":
                output_file.write(
                    "//*************---and command---************\n
	                A = M - 1\n
	                D = M\n
	                A = A - 1\n
	                M = M&D\n
	                @SP\n
	                M = M - 1\n");
                break;
            case "or":
                output_file.write(
                    "//*************---or command---************\n
                @SP\n
	            A = M - 1\n
	            D = M\n
	            A = A - 1\n
	            M = M|D\n
	            @SP\n
	            M = M - 1\n");
                break;
            case "not":
                output_file.write(
                    "//*************---not command---************\n
              @SP\n
	          A = M - 1\n
	          M = !M\n");
              break;
            default:
        }
    }
    void writePushOrPop(string cType,string segment, int index, string file_name){
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
                    case "that":
                        output_file.write(
                            "//*************---push this command---************\n
                        @THAT\n
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
                        @SP\n
                        M = M -1\n
                        A = M\n
                        D = M\n

                        @LCL\n
                        A = M\n");
                        for (int i = 0 ; i < index; i++){
                            output_file.write("A = A + 1");
                        }
                        output_file.write("
                        M = D\n");
                        break;
                    case "argument":
                        output_file.write(
                            "//*************---pop argument command---************\n
                        @SP\n
                        M = M -1\n
                        A = M\n
                        D = M\n

                        @ARG\n
                        A = M\n");
                        for (int i = 0 ; i < index; i++){
                            output_file.write("A = A + 1");
                        }
                        output_file.write("
                        M = D\n");
                        break;
                    case "this":
                        output_file.write(
                            "//*************---pop local command---************\n
                        @SP\n
                        M = M -1\n
                        A = M\n
                        D = M\n

                        @THIS\n
                        A = M\n");
                        for (int i = 0 ; i < index; i++){
                            output_file.write("A = A + 1");
                        }
                        output_file.write("
                        M = D\n");
                        break;
                    case "that":
                        output_file.write(
                            "//*************---pop local command---************\n
                        @SP\n
                        M = M -1\n
                        A = M\n
                        D = M\n

                        @THAT\n
                        A = M\n");
                        for (int i = 0 ; i < index; i++){
                            output_file.write("A = A + 1");
                        }
                        output_file.write("
                        M = D\n");
                        break;
                    case "static":
                    //not shure where static is
                        output_file.write(
                            "//*************---pop static command---************\n
                          @SP\n
                        A = M -1\n
                        D = M\n

                        @" ~file_name~ "." ~ to!string(index)~
                        "\nM = D \n

                        @SP\n
                        M = M -1\n"
                        );
                        break;
                    case "pointer":
                        index += 3;
                        output_file.write(
                         "//*************---pop pointer command---************\n

                        @SP\n
                        A = M -1\n
                        D = M\n

                        @"~to!string(index)~
                        "\nM = D\n
                        A = D\n
                        @SP\n
                        M = M - 1\n"
                        );
                        break;
                    case "temp":
                        index += 5;
                        output_file.write(
                            "//*************---pop temp command---************\n
                        @SP\n
                        A=M-1\n
                        D=M\n
                        @"~to!string(index)~
                        "M=D\n
                        @SP\n
                        M=M-1\n"
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