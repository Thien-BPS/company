#include <stdio.h>

int main()
{
    FILE* ffile;
    ffile = fopen("layer1.cpp", "w");
    fprintf(ffile, "#include <iostream>\n#include <fstream>\nusing namespace std;\n\nint main() {\n\tofstream fffile(\"layer2.py\");\n\tfffile << \"with open(\\\"layer3.sh\\\", \\\"w\\\") as f4ile:\\n\\tf4ile.write(\\\"echo \\\\\\\"File.write(\\\\\\\\\\\\\\\"layer5.js\\\\\\\\\\\\\\\",\\\\\\\\\\\\\\\"console.log(\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"Final layer.\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\")\\\\\\\\\\\\\\\")puts(\\\\\\\\\\\\\\\"Layer 5 done.\\\\\\\\\\\\\\\")\\\\\\\" >layer4.rb\\\\\\\\\necho Layer 4 done.\\\")\\nprint(\\\"Layer 3 done.\\\")\";\n\tfffile.close();\n\tcout << \"Layer 2 done.\";\n\treturn 0;\n}");
    fclose(ffile);
    printf("Layer 1 done.");
    return 0;
}