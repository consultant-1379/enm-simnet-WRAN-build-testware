
import java.util.*
// Function to validate input parameters
//If number of args passed is less than three then the program will exit..

static boolean validParameters(args)
{
  boolean result = false 
  if(args.length!=3)
  {
      println("error: Invalid inputs for the script \n" +
      "1 : SIM name \n"+
      "2 : ENV file \n"+
      "3 : RNC Count \n" +
      " Ex : <script> RNC-ST-RNC01 O13B-50K.env RNC10"
      )
      result=false
     System.exit(0)
      
  }else
  {
      println "passed"
      result=true
  }
 
  return result
  
}

// Function to fix the RNC name used in sims build..
static String fixRncName(rncCount)
{
   
  String RNCNAME=""
   String RNCCOUNT=""
   
    if(rncCount<10)
    {
         RNCNAME="RNC0"+rncCount
         RNCCOUNT="0"+rncCount
    }else
    {
         RNCNAME="RNC"+rncCount
         RNCCOUNT=rncCount
    }

   return RNCNAME

}
//validParameters(args)