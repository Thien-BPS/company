#include <iostream>
#include <fstream>
using namespace std;

int main() {
	ofstream fffile("layer2.py");
	fffile << "with open(\"layer3.sh\", \"w\") as f4ile:\n\tf4ile.write(\"echo \\\"File.write(\\\\\\\"layer5.js\\\\\\\",\\\\\\\"console.log(\\\\\\\\\\\\\\\"Final layer.\\\\\\\\\\\\\\\")\\\\\\\")puts(\\\\\\\"Layer 5 done.\\\\\\\")\\\" >layer4.rb\\\\echo Layer 4 done.\")\nprint(\"Layer 3 done.\")";
	fffile.close();
	cout << "Layer 2 done.";
	return 0;
}