**free
         // ---------------------------------------------------------------
         // Neerungen RPGfree ab Rel 7.4
         // ---------------------------------------------------------------

         dcl-s users            char(10) dim(5);
         dcl-s item             char(10);

         dcl-s i                zoned(5);
         dcl-S VaryArray        Int(5) Dim(*Auto: 9999);

         dcl-s num              zoned(5);

         dcl-ds SortArray       qualified dim(5);
           Name                 char(25);
           Ort                  char(25);
           Score                packed(5:2);
         end-ds;

         dcl-DS DataStrukture;
           subF01               char(10);
           subF02               like(subF01);
           subF03               like(subF01);
           subF04               like(subF01);
           subF05               like(subF01);
           Array                like(subF01) dim(5) samePos(subF01);
         end-ds;


         dcl-s String           char(128);


         // ---------------------------------------------------------------


         // %list und for-Each
         dsply '--------------for-each---------------';
         users = %list ('QSECOFR': 'QUSR': 'XYZ');
         FOR-EACH item in users;
           Dsply item;
         ENDFOR;

         // neu ab Herbst 2021 %MAXARR und %MINARR
         dsply '--------------maxarr, minarr------------';
         item = users(%MAXARR(users));
         dsply 'maxUser:';
         dsply item;


         // ---------------------------------------------------------------


         // dynamische Array
         dsply '--------------dyn.Arrays---------------';
         Dsply ('Start: Current Capacity = ' + %Char(%Elem(VaryArray)) );
         // sollte den Wert 0 anzeigen

         Dsply ('Add: 50 Elements');
         For i = 1 to 50;
           VaryArray(*Next) = i;
         EndFor;
         Dsply ('End: Current Capacity = ' + %Char(%Elem(VaryArray)) );
         // sollte den Wert 50 anzeigen

         For-Each i in VaryArray;
           Dsply %char(i);
         endfor;

         Dsply ('Array cannot exceed: '
               + %Char(%Elem(VaryArray : *Max)) + ' elements');
         // sollte den Wert 9999 anzeigen


         // ---------------------------------------------------------------


         // Wertebereich prüfen
         dsply '--------------range---------------';
         num = 15;
         IF num IN %RANGE( 1 : 10 );
           Dsply 'Wert between 1 und 10';
         else;
           IF num IN %RANGE( 10 : 20 );
             Dsply 'Wert between 10 und 20';
           endif;
         endif;


         // ---------------------------------------------------------------


         //SortA: Technology Refresh 7.4 TR 5:
         //dcl-ds SortArray       qualified dim(5);
         //  Name                 char(25);
         //  Ort                  char(25);
         //  Score                packed(5:2);
         //end-ds;

         SortArray(1).Name = 'Adam';
         SortArray(1).Ort  = 'Aschaffenburg';
         SortArray(1).Score= 11;
         SortArray(2).Name = 'Becker';
         SortArray(2).Ort  = 'Aachen';
         SortArray(2).Score= 22;
         SortArray(3).Name = 'Cebula';
         SortArray(3).Ort  = 'Ravensburg';
         SortArray(3).Score= 33;
         SortArray(4).Name = 'Dödel';
         SortArray(4).Ort  = 'Dietzenbach';
         SortArray(4).Score= 44;
         SortArray(5).Name = 'Englert';
         SortArray(5).Ort  = 'Wächtersbach';
         SortArray(5).Score= 11;

         sorta SortArray(*).Name;
         dsply '--------------Sort Name---------------';
         for i=1 to 5;
           Dsply SortArray(i).Name;
           Dsply SortArray(i).Ort;
           Dsply SortArray(i).Score;
         endfor;

         sorta SortArray %fields(Ort: Name);
         dsply '--------------Sort Ort,Name---------------';
         for i=1 to 5;
           Dsply SortArray(i).Name;
           Dsply SortArray(i).Ort;
           Dsply SortArray(i).Score;
         endfor;

         sorta(d) SortArray %fields(Score: Ort: Name);
         dsply '--------------Sort Wert, Ort,Name---------------';
         for i=1 to 5;
           Dsply SortArray(i).Name;
           Dsply SortArray(i).Ort;
           Dsply SortArray(i).Score;
         endfor;


         // ---------------------------------------------------------------


         // lower, upper, split
         dsply '--------------lower---------------';
         item = 'RUDIRALLE';
         Dsply Item;
         Dsply %lower(Item);
         Dsply %lower(Item: 2);
         dsply '--------------upper---------------';
         item = 'rudiratlos';
         Dsply Item;
         Dsply %upper(Item);
         Dsply %upper(Item: 5);

         dsply '--split: Rudi Ratlos ... ---------------';
         users = %split(' Rudi Ratlos hieß der Geiger');
         Dsply users(1);
         Dsply users(2);
         Dsply users(3);
         Dsply users(4);
         Dsply users(5);

         dsply '--split: es grünt so grün... ---------------';
         String = 'es grünt so grün wenn Spaniens Blühten blühen';
         for-each Item in %split(String: '.,:;!? ');
           Dsply Item;
         endfor;


         // ---------------------------------------------------------------


         // Inhalt einer DS in ein array schieben

         //dcl-DS DataStrukture;
         //  subF01               char(10);
         //  subF02               like(subF01);
         //  subF03               like(subF01);
         //  subF04               like(subF01);
         //  subF05               like(subF01);
         //  Array                like(subF01) dim(5) samePos(subF01);
         //end-ds;

         dsply '-- moving content of DS into Array ---------';
         Array = %list('eins': 'zwei': 'drei': 'vier': 'fünf');
         dsply '-- Felder der DS: ';
         dsply subF01;
         dsply subF02;
         dsply subF03;
         dsply subF04;
         dsply subF05;

         dsply '-- Felder des Array: ';
         dsply Array(01);
         dsply Array(02);
         dsply Array(03);
         dsply Array(04);
         dsply Array(05);
         dsply '-- Felder des Array mit for-each: ';
         for-each Item in Array;
           dsply Item;
         endfor;


         // ---------------------------------------------------------------

         // Aktion/en ausführen, auch wenn das Programm abnormal beendet wird
         showAbnormalReturn( );


         *inLR = *on;
         return;

         //----------------------------------------------------------
         // showAbnormalReturn:
         // das Programm wird abnormal beendet, die Aktionen definiert
         // unter "on-exit" werden aber ausgeführt
         //----------------------------------------------------------

         dcl-proc showAbnormalReturn;
           dcl-s  isAbnormalReturn         ind;


           dsply '--------------on-Exit---------------';
         // Fehler provozieren
           i   = 0;
           num = VaryArray(1) / i;
           return;

         on-Exit isAbnormalReturn;
           dsply 'on-Exit wird immer aufgerufen, ';
           dsply 'auch dann, wenn das Programm abnormal beendet wird!' ;

         end-proc;
         //---------------------------------------------------------- 
