module parser;
import std.stdio;
import std.file;
import std.path;
import std.array;
import std.conv;
import std.string;
public class Parser{
    private File p_file;
    private int line_num;
    private string[] lines;
    this(string input_file){ //constructor
        p_file = File (input_file,"r");
    }
    string current_command(){
        return lines[0];
    }
    void next(){
        lines = p_file.readln().split;
    }
    string commandType(){
        if (lines.length == 0)
            return "ERROR";
        switch(lines[0]){
            case "push":
                return "C_PUSH";
            case "pop":
                return "C_POP";
            case "add":
            case "sub":
            case "neg":
            case"eq":
            case"gt":
            case "lt":
            case "and":
            case "or":
            case "not":
                return "C_ARITHMETIC";
            case "if-goto":
                return "C_IF";
            case "goto":
                return "C_GOTO";
            case "label":
                return "C_LABEL";
            case "call":
                return "C_CALL";
            case "return":
                return "C_RETURN";
            case "function":
                return "C_FUNCTION";
            default:
                return "ERROR";
        }
    }
    string arg1(){
        switch(this.commandType()){
            case "C_PUSH":
            case "C_POP":
            case "C_LABEL":
            case "C_GOTO":
            case "C_IF":
            case "C_FUNCTION":
            case "C_CALL":
                return lines[1];
            case "C_ARITHMETIC":
                return lines[0];
            default:
                return "ERROR";
        }
    }
    string arg2(){
        switch(this.commandType()){
            case "C_PUSH":
            case"C_POP":
            case "C_FUNCTION":
            case "C_CALL":
                return lines[2];
            default:
                return "ERROR";
        }
    }
    bool HasMoreLines(){
        return !p_file.eof;
    }
    void close(){
        p_file.close();
    }
}
