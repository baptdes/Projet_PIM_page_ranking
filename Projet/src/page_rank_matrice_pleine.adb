with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with vecteurs;
with vecteurs.matrice_pleine;

package body page_rank_matrice_pleine is

   procedure page_rank (nombre_site : in Integer; alpha : in Float; k : in Integer ; epsilon : in Float ; Prefix : in Unbounded_String; nom_fichier_net : in Unbounded_String) is
      
      -- Instanciation des modules
      
         package vecteurs_float is new vecteurs(Capacite => nombre_site, T_Valeur => Float);
         use vecteurs_float;

         -- Renvoie True si le réel est nul
         function est_nul(x : Float) return Boolean is
         begin
            return abs(x) < 0.000001;
         end est_nul;

         package Matrice_pleine is new vecteurs_float.Matrice_pleine(Capacite => nombre_site, zero => 0.0, est_nul =>est_nul);
         use Matrice_pleine;

         -- On instancie max et distance qui sont des fonctions génériques
         function max is new vecteurs_float.max;
         function distance is new vecteurs_float.distance;

      --Variables
         poubelle : Integer; -- Pour lire une ligne du fichier net dans le vide
         i : Integer; -- Indice pour parcourir des listes
         indice : Integer;
         fichier : Ada.Text_IO.File_Type; --Fichier .net à lire
         Fichier_pr : Ada.Text_IO.File_Type; --Fichier .pr à créer
         Fichier_prw : Ada.Text_IO.File_Type; --Fichier .prw à créer
         depart : Integer; --Numéro site dé
         arrive : Integer;
         -- Nombre de liaison d'un site
         s : Float;
         --Vecteurs poids
         pik : T_vecteur;
         pik_prec : T_vecteur;
         tri_pik : T_vecteur;
         --Vecteur pahe rank
         page_rank : T_vecteur;
         -- Matrices
         M_S : T_mat;
         M_I : T_mat;
         G : T_mat; -- Matrice de google
         -- Nom fichiers
         Nom_fichier_pr : Unbounded_String;
         Nom_fichier_prw : Unbounded_String;
   begin
      -- Passer une ligne dans la lecture du fichier
      open (fichier, In_File, To_String(nom_fichier_net));
      Get (fichier, poubelle);

         --Déterminer H grâce au fichier graphe
      Initialiser_matrice(nombre_site,nombre_site,0.0,M_S);

      -- Calculer la matrice M_S
      begin
         -- Tant qu'il y a encore des valeurs à lire
         while not End_Of_file (fichier) loop
            -- Lire les deux prochaines valeurs
            Get (fichier, depart);
            Get (fichier, arrive); 
            -- Mettre un 1 dans la matrice pour signifier le lien
            M_S.Mat(depart+1,arrive+1) := 1.0;
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
            for j in 1..M_S.nombre_colonne loop
               M_S.Mat(i,j) := 1.0/Float (nombre_site);
            end loop;
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

      -- Calculer G
      Initialiser_matrice(nombre_site,nombre_site,1.0,M_I);
      G := (alpha * M_S) + (((1.0-alpha)/Float (nombre_site)) * M_I);

      --Calculer le vecteur des poids
      Initialiser_vecteur(nombre_site,1.0/Float(nombre_site),pik);
      i := 1;
      loop
         pik_prec := pik;
         pik := pik * G;
         i := i + 1;
      exit when (i > k) or else (distance(pik,pik_prec) < epsilon);
      end loop;

      -- Calculer le page rank
      Tri_pik := pik;
      Initialiser_vecteur(nombre_site,0.0,page_rank);
      for i in 1..nombre_site loop
         indice := max(Tri_pik);
         page_rank.tab(i) := Float(indice) - 1.0;
         Tri_pik.tab(indice) := 0.0;
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
         Put (Fichier_pr, Integer(page_rank.tab(i)),1);
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
      for i in 1..nombre_site loop
         Put (Fichier_prw, pik.tab(i),1);
         New_Line (Fichier_prw);
      end loop;
      close (Fichier_prw);

   end page_rank;
end page_rank_matrice_pleine;