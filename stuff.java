class stuff {
    public static void main(String[] args) {

        // Print string literal
        System.out.println("Hello World!");

        // Print variable string
        String message = "Good Morning!";
        System.out.println(message);

        // Data types

        /*
          int (integer 2.14 billion to -2.14 billion)
          byte (integer 127 to -128)
          short (integer 32,767 to -32,768)
          long (long integer)
          float (floating point number)
          double (long floating point number)
          char (character)
          boolean (boolean value)
          String (a series of unicode characters)
        */

        int num1 = 1292;
        byte num2 = 3;
        short num3 = 105;
        long num4 = 10340;
        float num5 = 123.456789f;
        double num6 = 12345.6789101112f;
        char a = 'A';
        boolean b = false;
        String str = "Hello Universe!";

        // Print data types
        System.out.println("num1: " + num1);
        System.out.println("num1: " + num2);
        System.out.println("num3: " + num3);
        System.out.println("num4: " + num4);
        System.out.println("num5: " + num5);
        System.out.println("num6: " + num6);
        System.out.println("a: " + a);
        System.out.println("b: " + b);
        System.out.println("str: " + str);

        // Math

        /*
          + operator (addition)
          - operator (subtraction)
          * operator (multiplication)
          / operator (division)
          % operator (modulo)
        */
        
        System.out.println(1 + 1);
        System.out.println(2 - 1);
        System.out.println(4 * 3);
        System.out.println(10 / 5);
        System.out.println(7 % 4);

        // Assignment

        /*
          +=
          -=
          *=
          /=
          %=
        */

        int myValue = 234;
        myvalue += 10; // 244
        myvalue -= 44; // 200
        myvalue *= 2; // 400
        myvalue /= 8; // 50
        myvalue %= 20; // 10
        System.out.println("myValue: " + myValue);          

        // Binary Operators!

        /*
          & operator (and)
          | operator (or)
          ~ operator (not)
          ^ operator (xor)
          >> operator (right shift)
          << operator (left shift)
        */
        
        System.out.print(0 & 1);
        System.out.print(0 | 1);
        System.out.print(~1);
        System.out.print(16 >> 2);
        System.out.print(1 << 4 + '\n');

        int flags = 42; // 00101010
        // Read the individual bits from the int
        System.out.println("Bit 1:" + int&1);
        System.out.println("Bit 2:" + int&2);
        System.out.println("Bit 3:" + int&4);
        System.out.println("Bit 4:" + int&8);
        System.out.println("Bit 5:" + int&16);
        System.out.println("Bit 6:" + int&32);
        System.out.println("Bit 7:" + int&64);
        System.out.println("Bit 8:" + int&128);

        // If Else
        if (b == false) {
            // This code never executes
        } else {
            // This code always executes
        }
        
        if (1 == 1) {
            // This code executes if 1 == 1
        } else {
            // This code executes if 1 != 1
        }
        
        // If
        if ((3 - 1) == 2) {
            // Executes if 3 - 1 == 2
        }

        // While
        int counter = 1;
        while (counter < 10) {
            System.out.println("Message " + counter + "\n");
        }

        // For
        for (int i = 0; i < 10; i++) {
            System.out.println("Iteration " + i + "\n");
        }

        // Do While
        do {
            // This will execute at least once even if the while condition is false
            System.out.println("Good Afternoon!\n");
        } while (0) {
            // Nothing here :D
        }

        // Switch
        switch ("Joe") {
            case "Bob":
                System.out.println("Hi Bob!");
                break;
            case "Joe":
                System.out.println("Hi Joe!");
                break;
            case "Bill":
                System.out.println("Hi Bill!");
                break;
            default:
                System.out.println("Hi!");
                break;
        }
        
        // Break

        for (i = 0; i < 10; i++) {
            System.out.println("Iteration #" + i);
            if (i == 5) {
                break;
            }
        }
    
        // Continue

        for (i = 0; i < 3; i++) {
            if (i == 2) {
                continue;
            }
            System.out.println("Hello " + i);
        }

        // Return control

        label: for (i = 0; i < 3; i++) {
            System.out.println(i);
            for (int ii = 0; ii < 3; ii++) {
                System.out.println(ii);
                if (ii == 2) {
                    continue label;
                }
            }
        }

        // Ternary operator
        
        System.out.println(1 + 1 == 2 ? "True" : "False");

        // Logic

        /*
          == (equals)
          != (not equals)
          ! (not)
          || (or)
          && (and)
          > (greater than)
          < (less than)
          >= (greater than or equal to)
          <= (less than or equal to)
        */

        // Escape literals

        /*
          \\ (backslash)
          \n (newline)
          \t (tab)
          \r (return)
          \b (backspace)
          \f (formfeed)
          \' (single quote)
          \" (double quote)
        */

        // Casting
        
        float pi = 3.14159236;
        System.out.println((int) pi);

        // Arrays

        String[] arr = {"Hello ", "World", "\n"}
        for (i = 0; i < 3; i++) {
            System.out.print(arr[i]);
        }

        int[] favNums;
        favNums[0] = 12;
        favNums[1] = 465;
        favNums[2] = 293;
        System.out.println(favNums[0] + favNums[1] + favNums[2]);

        // CLI arguments
        
        System.out.println(args.length + " Arguments");
    }
}
