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
#include "Node.mqh"
#include "imbalance.mqh"
int riskCount = 0;

input ENUM_TIMEFRAMES entryTF = PERIOD_M1;
input ENUM_TIMEFRAMES midTF = PERIOD_M5;
input ENUM_TIMEFRAMES dirTF = PERIOD_M15;
datetime lastTimeContext = 0;
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
      universe[symID].tf = midTF;
      double spread = SymbolInfoDouble(sym, SYMBOL_ASK) - SymbolInfoDouble(sym, SYMBOL_BID);
      context cnx();
      cnx.scan(sym, dirTF);
      context cEntry();
      cEntry.scan(sym, midTF);
      if(lastTimeContext != cnx.time)
        {
         riskCount = 0;
         lastTimeContext = cnx.time;
        }
      if(riskCount >= 1)
         return;
      int direction = cnx.direction(CONTEXT_HOLD);
      int entDir = cEntry.direction(CONTEXT_REJECT);
      imbalance imb();
      imb.scan(sym, entryTF, entDir, cEntry.candleTouchIndex);
      if(direction == 1 && entDir)
        {
         node nd();
         orderType = "limit";
         entry = imb.startPrice;
         // nd.scan(sym, 1,dirTF, 1, 2);
         sl =imb.endPrice;
         tp = entry + (entry - sl) * 4;
         closeAll(sym, -1);
         deleteAll(sym, 1);
         deleteAll(sym, -1);
         buy(symID, orderType, entry, sl, tp, 1,entryTF);
        }
      else
         if(direction == -1 && entDir)
           {
            node nd();
            orderType = "limit";
            entry = imb.startPrice;
            // nd.scan(sym, -1,dirTF, 1, 2);
            sl = imb.endPrice + spread;
            tp = entry - (sl - entry) * 4;
            closeAll(sym, 1);
            deleteAll(sym, 1);
            deleteAll(sym, -1);
            sell(symID, orderType, entry, sl, tp, 1, entryTF);
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
