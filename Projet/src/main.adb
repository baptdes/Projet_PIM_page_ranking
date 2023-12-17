with Ada.IO_Exceptions;
with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Command_line;		use Ada.Command_line; -- Module pour lire les arguments de la commande
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Matrice;

procedure Main is
   -- Instanciation matrice
   package Matrice_80 is new Matrice(Capacite => 15);
   use Matrice_80;
   
   --Exceptions
      arguments_invalides : exception;
      erreur_lecture_fichier : exception;
      No_Argument_Error : exception;
   
   --Variables
      alpha : Float; --Valeur de alpha
      k : Integer;  -- Indice k du vecteur poids à calculer
      epsilon : Float; --Valeur de epsilon
      Prefix : Unbounded_String; -- Préfixe des fichiers résultats
      Pleine : Boolean; -- Booleen pour choisir l’algorithme avec des matrices pleines (true) ou creuses (false)
      i : Integer; -- Indice pour parcourir des listes
      nombre_site : Integer; -- Nombre de sites dans le graphe
      fichier : Ada.Text_IO.File_Type; --Fichier .net à lire
      Fichier_pr : Ada.Text_IO.File_Type; --Fichier .pr à créer
      Fichier_prw : Ada.Text_IO.File_Type; --Fichier .prw à créer
      page_source : Integer; --Numéro site dé
      b : Integer;
      -- Nombre de liaison d'un site
      s : Float;
      --Vecteurs poids
      pik : T_mat;
      pik_prec_T : T_mat;
      pik_T : T_mat;
      Tri_pik : T_mat;
      --Vecteur pahe rank
      page_rank : T_mat;
      -- Matrices
      M_S : T_mat;
      M_I : T_mat;
      G : T_mat; -- Matrice de google
      -- Indice de la ligne max
      indice : Integer;
      -- Nom fichiers
      Nom_fichier_pr : Unbounded_String;
      Nom_fichier_prw : Unbounded_String;

      -- Procedures
      procedure Traiter_arguments(i : in out Integer) is
      begin
         i := 1;
         while (i<Argument_Count) loop
            begin
                  Put("ici");
                  if Argument(i) = "-A" then
                     alpha := float'Value(Argument(i+1));
                     i := i + 2;
                  elsif Argument(i) = "-K" then 
                     k := integer'Value(Argument(i+1));
                     i := i + 2;
                  elsif Argument(i) = "-E" then
                     epsilon := float'Value(Argument(i+1));
                     i := i + 2;
                  elsif Argument(i) = "-P" then
                     Pleine := True;
                     i := i + 1;
                  elsif Argument(i) = "-C" then
                     i := i + 1;
                  elsif Argument(i) = "-P" then
                     Prefix := To_Unbounded_String(Argument(i+1));
                     i := i + 2;
                  else
                     raise arguments_invalides;
                  end if;
               exception
                  when others => raise arguments_invalides;
            end;
         end loop;
      end Traiter_arguments;
begin
   --Initialiser le programme
   
   --Initialiser les variables
   alpha := 0.85;
   k := 150;
   epsilon := 0.0;
   Prefix := To_Unbounded_String("output");
   Pleine := False;

   -- Vérifier si il a potentiellement le nom du fichier
	if Argument_Count < 1 then
		raise No_Argument_Error;
	end if;

   --Traiter la commande
   Traiter_arguments(i);

   --Déterminer H grâce au fichier graphe
   Put(Argument(Argument_Count));
   open (fichier, In_File, Argument(Argument_Count));
   Get (fichier, nombre_site);
   Initialiser(nombre_site,nombre_site,0.0,M_S);

   -- Calculer la matrice M_S
	begin
      -- Tant qu'il y a encore des valeurs à lire
		while not End_Of_file (fichier) loop
         -- Lire les deux prochaines valeurs
			Get (fichier, page_source);
         Get (fichier, b); 
         -- Mettre un 1 dans la matrice pour signifier le lien
         M_S.Mat(page_source+1,b+1) := 1.0;
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
      if ligne_vide(M_S,i) then
         -- Remplir la ligne de 1/nombre de site
         Modifier_ligne(M_S,i,1.0/Float (nombre_site));
      else
         -- Calculer le nombre de liaison du site (i-1)
         s := 0.0;
         for j in 1..nombre_site loop
            s := s + M_S.Mat(i,j);
         end loop;

         -- Diviser la ligne par le nombre de liaison
         for j in 1..nombre_site loop
            M_S.Mat(i,j) := M_S.Mat(i,j) / s;
         end loop;
      end if;
   end loop;
   Close (fichier);

   -- Calculer G (OK)
   Initialiser(nombre_site,nombre_site,1.0,M_I);
   G := addition(multiplier_scalaire(M_S,alpha),multiplier_scalaire(M_I,(1.0-alpha)/Float (nombre_site)));

   --Calculer le vecteur des poids
   Initialiser(nombre_site,1,1.0/Float(nombre_site),pik);
   i := 1;
   pik_T := Transpose(pik);
   loop
      pik_prec_T := pik_T;
      pik_T := Multiplication(pik_T,G);
   exit when (i<nombre_site) and then (norme(Addition(pik_T,multiplier_scalaire(pik_prec_T,-1.0)))>epsilon);
   end loop;
   pik := Transpose(pik_T);

   -- Calculer le page rank
   Tri_pik := pik;
   Initialiser(nombre_site,1,0.0,page_rank);
   for i in 1..nombre_site loop
      indice := Ligne_max(Tri_pik);
      page_rank.Mat(i,1) := Float(indice) - 1.0;
      Tri_pik.Mat(indice,1) := 0.0;
   end loop;

   --Enregistrer le fichier .pr et .pwd

   -- Créer les noms de fichiers
   Nom_fichier_pr := Prefix;
   Nom_fichier_prw := Prefix;
   Append (Nom_fichier_pr, ".pr");
   Append (Nom_fichier_prw, ".prw");

   -- Créer le fichier .pr
	Create (Fichier_pr, Out_File, To_String (Nom_fichier_pr));
   for i in 1..nombre_site loop
      Put (Fichier_pr, Integer(page_rank.Mat(i,1)),1);
      New_Line (Fichier_pr);
   end loop;
	close (Fichier_pr);

    --Créer le fichier .prw
   Create (Fichier_prw, Out_File, To_String (Nom_fichier_prw));
   Put (Fichier_prw, nombre_site, 1);
   Put (Fichier_prw, " ");
   Put (Fichier_prw, alpha);
   Put (Fichier_prw, " ");
   Put (Fichier_prw, K, 1);
   New_Line (Fichier_prw);
   Afficher(pik);
   for i in 1..nombre_site loop
      Put (Fichier_prw, pik.Mat(i,1),1);
      New_Line (Fichier_prw);
   end loop;
	close (Fichier_prw);

end Main;
