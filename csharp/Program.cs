using System;

namespace csharp
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("What do you want to say? ");
            string? getInput = Console.ReadLine();
            Console.WriteLine(getInput);
        }
    }
}