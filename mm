#property strict

extern int MagicNumber = 123456;
extern double Lots = 0.1;

int start() {
   if (Period() != 30 || Symbol() != "XAUUSD") return 0;

   int i, r;
   double A, B, C, D;
   double entryPrice, stopLoss, takeProfit;

   //===================== SELL PATTERN ========================
   for (i = 50; i >= 10; i--) {
      if (i + 5 >= Bars || i - 5 < 0) continue;  // جلوگیری از خطا
      
      A = Low[i + 5];
      B = Low[i];
      C = Low[i - 5];

      if (B < A && C < B) {
         D = B + (C - B) / 2.0;
         if (Close[1] >= D && Close[0] < D) {
            entryPrice = Bid;
            stopLoss = High[i];
            takeProfit = C;

            Print("SELL: A=", A, " B=", B, " C=", C, " D=", D);
            Print("Entry=", entryPrice, " SL=", stopLoss, " TP=", takeProfit);

            r = OrderSend(Symbol(), OP_SELL, Lots, entryPrice, 3, stopLoss, takeProfit, "Sell ABCD", MagicNumber, 0, Red);
            if (r < 0) Print("Sell order failed. Error:", GetLastError());
            break;
         }
      }
   }

   //===================== BUY PATTERN ========================
   for (i = 50; i >= 10; i--) {
      if (i + 5 >= Bars || i - 5 < 0) continue;

      A = High[i + 5];
      B = High[i];
      C = High[i - 5];

      if (B > A && C > B) {
         D = B + (C - B) / 2.0;
         if (Close[1] <= D && Close[0] > D) {
            entryPrice = Ask;
            stopLoss = Low[i];
            takeProfit = C;

            Print("BUY: A=", A, " B=", B, " C=", C, " D=", D);
            Print("Entry=", entryPrice, " SL=", stopLoss, " TP=", takeProfit);

            r = OrderSend(Symbol(), OP_BUY, Lots, entryPrice, 3, stopLoss, takeProfit, "Buy ABCD", MagicNumber, 0, Blue);
            if (r < 0) Print("Buy order failed. Error:", GetLastError());
            break;
         }
      }
   }

   return 0;
}
