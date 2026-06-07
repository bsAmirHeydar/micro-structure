//+------------------------------------------------------------------+
//|                                             strategy setting.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
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

#include "draw.mqh"
#include "order.mqh"
#include "micro filter.mqh"
#include "volatility.mqh"


double minATRFactor =0; //Minimum ATR Factor
double defaultSLATRFactor = 2; //Default SL ATR Factor
double maxATRFactor = 20000; //Max ATR Factor
bool tradeCondition = false;
bool closeCondition = false;
bool regimCondition = false;
bool resetCondition = false;
int riskCount = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class strategy
  {
public:
   int               symID;
   string            orderType;
   double            entry;
   double            sl;
   double            tp;
   double            volFactor;
   double            buySL;
   double            sellSL;
   double            buyEntry;
   double            sellEntry;
   int               buyIndex;
   int               sellIndex;
   double            buyStopValue;
   double            sellStopValue;
   void              initial(int _symID)
     {
      symID = _symID;
     }
   void              run(bool _justTrail = false)
     {
      string sym = universe[symID].name;
      ENUM_TIMEFRAMES entryTF = PERIOD_CURRENT;
      universe[symID].tf = entryTF;
      if(entryTF == TF_INVALID)
         return;
      double spread = SymbolInfoDouble(sym, SYMBOL_ASK) - SymbolInfoDouble(sym, SYMBOL_BID);
      double highest = iHigh(sym, entryTF, iHighest(sym, entryTF, MODE_HIGH, 20, 2));
      double lowest = iLow(sym, entryTF, iLowest(sym, entryTF, MODE_LOW, 20, 2));
      double price = iClose(sym, entryTF, 1);
      static datetime lastBarTime = 0;
      datetime curBarTime = iTime(sym, entryTF, 0);
      if(!(curBarTime == lastBarTime))
        {
         lastBarTime = curBarTime;
         // run every candle
         regimCondition = volState(sym, PERIOD_H1, 1,5,20,1.0,VOL_RATIO_ABOVE, AGG_RMS, SRC_CC, 0);
         tradeCondition = volState(sym, entryTF, 5, 10, 100, 1.0, VOL_RATIO_ABOVE, AGG_MED, SRC_CC);
         closeCondition = volState(sym, entryTF, 5, 10, 100, 0.85, VOL_RATIO_BELOW, AGG_MED, SRC_CC);
         resetCondition = volState(sym, entryTF, 5, 10, 100, 0.85, VOL_RATIO_BELOW, AGG_MED, SRC_CC);
        }
      if(resetCondition)
         riskCount = 0;
      if(closeCondition)
        {
         riskCount = 0;
         closeAll(sym, 1);
         closeAll(sym, -1);
        }
      if(!closeCondition && (regimCondition && tradeCondition) && riskCount < 1)
        {
         double atrArray[];
         int atrIndex = iATR(sym, entryTF, 14);
         CopyBuffer(atrIndex,0,0,1,atrArray);
         double atr = atrArray[0];
         double maxATR = maxATRFactor * atr;
         double minATR = minATRFactor * atr;
         double higherHighSL = price + maxATR;
         double lowerHighSL = price + minATR;
         double lowerLowSL = price - maxATR;
         double higherLowSL = price - minATR;
         WeakRangeResult wr =  FindWeakRange(sym, entryTF, 5, 5, 10, 100, 1, AGG_MED, SRC_CC, 1, 500);
         if(price > wr.highestHigh)
           {
            entry = SymbolInfoDouble(sym, SYMBOL_ASK);
            //   if(lowest > lowerLowSL && lowest < higherLowSL)
            //    sl = lowest;
            //  else
            //    sl = price - (defaultSLATRFactor * atr);
            sl = wr.lowestLow;
            riskCount ++;
            buy(symID, orderType, entry, sl, 0, 1, entryTF);
           }
         else
            if(price < wr.lowestLow)
              {
               entry = SymbolInfoDouble(sym, SYMBOL_BID);
              // if(highest < higherHighSL && highest > lowerHighSL)
               //   sl = highest + spread;
             //  else
              //    sl = price + (defaultSLATRFactor * atr) + spread;
              sl = wr.highestHigh;
               riskCount++;
               sell(symID, orderType, entry, sl, 0, 1, entryTF);
              }
        }
     }
   void              reset(int _type)
     {
      if(_type == 1)
        {
         buyIndex = 0;
         buyEntry = 0.0;
         buySL = 0.0;
         buyStopValue = 0.0;
        }
      else
         if(_type == -1)
           {
            sellIndex = 0;
            sellEntry = 0.0;
            sellSL = 0.0;
            sellStopValue = 0.0;
           }
     }
                     strategy()
     {
      orderType = "market";
     }
                    ~strategy(void) {}
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
