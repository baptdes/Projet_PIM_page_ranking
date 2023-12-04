with Ada.IO_Exceptions;
with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
-- Module pour lire les arguments de la commande
with Ada.Command_line;		use Ada.Command_line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
   --Exceptions
      arguments_invalides : exception;
   
   --Variables
      --Valeur de alpha
      alpha : Float;
       -- Indice k du vecteur poids à calculer
      k : Integer;
      --Valeur de epsilon
      epsilon : Float;
      -- Préfixe des fichiers résultats
      Prefix : String;
      -- Booleen pour choisir l’algorithme
      -- avec des matrices pleines (true) ou creuses (false)
      Pleine : Boolean;
      -- Indice pour parcourir des listes
      i : Integer;
      -- Nom du fichier contenant le graphe
      nom_fichier : String;

begin
   --Initialiser le programme
   
   --Initialiser les variables
   alpha = 0.85;
   k = 150;
   epsilon = 0.0;
   Prefix = "output";
   Pleine = False;

   --Traiter la commande
   i = 0;
   while (i<Argument_Count) loop
      begin
         case Argument(i) is
            "-A" => alpha = float'Value(Argument(i+1)); i = i + 2;
            "-K" => k = integer'Value(Argument(i+1)); i = i + 2;
            "-E" => epsilon <- float'Value(Argument(i+1)); i = i + 2;
            "-P" => i = i + 1;
            "-C" => i = i + 1;
            "-P" => Prefix = Argument(i+1); i = i + 2;
         End Case;
         exception
            with others => raise arguments_invalides;
      end
      nom_fichier = Argument(Argument_Count);

   --Déterminer H grâce au fichier graphe
   

end Main;
