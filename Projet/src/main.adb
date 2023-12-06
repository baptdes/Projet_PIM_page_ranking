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
      --Les fichiers
      fichier : Ada.Text_IO.File_Type;
      Fichier_pr : Ada.Text_IO.File_Type;
      Fichier_prw : Ada.Text_IO.File_Type;
      --Variables utlisé pour la lecture du fichier
      a : Integer;
      b : Integer;
      -- Nombre de liaison d'un site
      s : Integer;
      --Vecteurs poids
      pik : T_matrice;
      pik_prec : T_matrice;
      -- Matrices
      S : T_matrice;
      I : T_matrice;
      -- Indice de la ligne max
      indice : T_matrice;
      -- Nom fichiers
      Nom_fichier_pr : Unbounded_String;
      Nom_fichier_prw : Unbounded_String;

begin
   --Initialiser le programme
   
   --Initialiser les variables
   alpha := 0.85;
   k := 150;
   epsilon := 0.0;
   Prefix := "output";
   Pleine := False;

   --Traiter la commande
   i := 1;
   while (i<Argument_Count) loop
      begin
         case Argument(i) is
            "-A" => alpha := float'Value(Argument(i+1)); i := i + 2;
            "-K" => k := integer'Value(Argument(i+1)); i := i + 2;
            "-E" => epsilon := float'Value(Argument(i+1)); i := i + 2;
            "-P" => i := i + 1;
            "-C" => i := i + 1;
            "-P" => Prefix := To_Unbounded_String(Argument(i+1)); i := i + 2;
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

   -- Calculer G
   I = Initialiser_matrice(nombre_site,nombre_site,1);
   G = addition(multiplier_scalaire(H,alpha),multiplier_scalaire(I,(1-alpha)/nombre_site));

   --Calculer le vecteur des poids
   pik := Initialiser_matrice(nombre_site,1,1/nombre_site);
   i := 1
   loop
      pik_prec := pik;
      pik := Produit_matriciel(pik,G);
   exit when (i<nombre_site)&&(norme(soustraction(pik,pik_prec)))
   end loop;

   -- Calculer le page rank
   page_rank := Initialiser_matrice(nombre_site,1,0);
   for i in 1..nombre_site loop
      indice := Ligne_max(pik);
      page_rank(i) := indice;
      pik(indice) := 0;
   end loop;
   --Enregistrer le fichier .pr et .pwd

   -- Créer les noms de fichiers
   Nom_fichier_pr := To_Unbounded_String (Prefixe);
   Nom_fichier_prw := Nom_fichier_pr;
   Append (Nom_fichier_pr, ".pr");
   Append (Nom_fichier_prw, ".prw");

   -- Créer le fichier .pr
	Create (Fichier_pr, Out_File, To_String (Nom_fichier_pr));
   for i in 1..nombre_site loop
      Put (Fichier_pr, String'Value(page_rank(i)));
      New_Line (Fichier_pr);
   end loop;
	close (Fichier_pr);

   --Créer le fichier .prw
   Create (Fichier_prw, Out_File, To_String (Nom_fichier_prw));
   Put (Fichier_prw, String'Value(nombre_site) & " ");
   Put (Fichier_prw, String'Value(alpha) & " ");
   Put (Fichier_prw, String'Value(K));
   New_Line (Fichier_prw);
   for i in 1..nombre_site loop
      Put (Fichier_prw, String'Value(pik(i)));
      New_Line (Fichier_prw);
   end loop;
	close (Fichier_prw);

end Main;
