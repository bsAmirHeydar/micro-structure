//+------------------------------------------------------------------+
//|                                                    imbalance.mqh |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
class imbalance
  {
public:
   string            sym;
   ENUM_TIMEFRAMES   tf;
   int               type;
   double            startPrice;
   double            endPrice;
   int               startIndex;
   int               endIndex;
   void              scan(string _sym, ENUM_TIMEFRAMES _tf,int _type, int _endIndex)
     {
      sym = _sym;
      tf= _tf;
      type = _type;
      for(int i=1;i<_endIndex;i++)
        {
         if(type == 1)
           {
            double low = iLow(sym, tf, i);
            double high = iHigh(sym, tf, i+2);
            if(low > high)
              {
               startPrice = low;
               endPrice = iLow(sym, tf, i+2);
               startIndex = i;
               endIndex = i+2;
               if(!isBreak())
                  break;
               else
                  reset();
              }
           }
         else
            if(type==-1)
              {
               double high = iHigh(sym, tf, i);
               double low = iLow(sym, tf, i+2);
               if(high < low)
                 {
                  startPrice = high;
                  endPrice = iHigh(sym, tf, i+2);
                  startIndex = i;
                  endIndex = i+ 2;
                  if(!isBreak())
                     break;
                  else
                     reset();
                 }
              }
        }
     }
   bool              isBreak()
     {
      for(int i=0;i<startIndex;i++)
        {
         double high = iHigh(sym, tf, i);
         double low = iLow(sym, tf, i);
         if(type == 1)
           {
            if(low < startPrice)
              {
               return true;
              }
           }
         else
            if(type == -1)
              {
               if(high > startPrice)
                 {
                  return true;
                 }
              }
        }
      return false;
     }
   void              reset()
     {
      startPrice = 0;
      endPrice = 0;
      startIndex = 0;
      endIndex = 0;
     }
                     imbalance(void) {}
                    ~imbalance(void) {}
  };
//+------------------------------------------------------------------+
