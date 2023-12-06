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
      erreur_lecture_fichier : exception;
   
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
      -- Nombre de sites dans le graphe
      nombre_site : Integer;
      fichier : Ada.Text_IO.File_Type;
      --Variables utlisé pour la lecture du fichier
      a : Integer;
      b : Integer;
      -- Nombre de liaison d'un site
      s : Integer;

begin
   --Initialiser le programme
   
   --Initialiser les variables
   alpha := 0.85;
   k := 150;
   epsilon := 0.0;
   Prefix := "output";
   Pleine := False;

   --Traiter la commande
   i := 0;
   while (i<Argument_Count) loop
      begin
         case Argument(i) is
            "-A" => alpha := float'Value(Argument(i+1)); i := i + 2;
            "-K" => k := integer'Value(Argument(i+1)); i := i + 2;
            "-E" => epsilon := float'Value(Argument(i+1)); i := i + 2;
            "-P" => i := i + 1;
            "-C" => i := i + 1;
            "-P" => Prefix := Argument(i+1); i := i + 2;
         End Case;
         exception
            with others => raise arguments_invalides;
      end
      nom_fichier = Argument(Argument_Count);

   --Déterminer H grâce au fichier graphe
   open (fichier, In_File, nom_fichier);
   Get (fichier, nombre_site);
   S := Initialiser_matrice(nombre_site,nombre_site,0);

   -- Calculer la matrice S
	begin
      -- Tant qu'il y a encore des valeurs à lire
		while not End_Of_file (fichier) loop
         -- Lire les deux prochaines valeurs
			Get (fichier, a);
         Get (fichier, b); 
         -- Mettre un 1 dans la matrice pour signifier le lien
         S(a+1,b+1) := 1;
		end loop;
	exception
		when End_Error =>
			null;
		when Others =>
         raise erreur_lecture_fichier;
	end;

   -- Pour chaque ligne
   for i in 1..nombre_site loop
      -- Si la ligne est vide
      if ligne_vide(S,i) then
         -- Remplir la ligne de 1/nombre de site
         Modifier_ligne(S,i,1/nombre_site);
      else
         -- Calculer le nombre de liaison du site (i-1)
         s := 0
         for j in 1..nombre_site loop
            s := s + S(i,j);
         end loop;

         -- Diviser la ligne par le nombre de liaison
         for j in 1..nombre_site loop
            S(i,j) := S(i,j) / s;
         end loop;
      end if;
   end loop;
   Close (fichier);
end Main;
