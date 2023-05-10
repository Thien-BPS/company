#include <stdio.h>

int main()
{
    FILE* ffile;
    ffile = fopen("layer1.cpp", "w");
    fprintf(ffile, "\#include <iostream>\n\#include <fstream>\nusing namespace std;\n\nint main() {\n\tofstream fffile(\"layer2.py\");\n\t}");
    fclose(ffile);
    return 0;
}