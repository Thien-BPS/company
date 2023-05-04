#include "../stuff/string.h"
byte CString::Strlen(
        const char far* inStrSource 
        )
{
        byte lenghtOfString = 0;
        
        while(*inStrSource++ != '')
        {
            ++lenghtOfString;
        }
        return lenghtOfString;
}