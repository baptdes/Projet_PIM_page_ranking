with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with vecteurs;
with vecteurs.matrice_creuse;

package body page_rank_matrice_creuse is

   procedure page_rank (nombre_site : in Integer; alpha : in Float; k : in Integer ; epsilon : in Float ; Prefix : in Unbounded_String; nom_fichier_net : in Unbounded_String) is
      
      -- Instanciation des modules

         package vecteurs_float is new vecteurs(Capacite => nombre_site, T_Valeur => Float);
         use vecteurs_float;

         -- Renvoie True si le réel est nul
         function est_nul(x : Float) return Boolean is
         begin
            return abs(x) < 0.000001;
         end est_nul;

         package Matrice_creuse is new vecteurs_float.Matrice_creuse(Taille => nombre_site/2, zero => 0.0,est_nul => est_nul);
         use Matrice_creuse;

         -- On instancie max, distance et Multiplication_S qui sont des fonctions génériques
         function max is new vecteurs_float.max;
         function distance is new vecteurs_float.distance;
         function Multiplication_S is new Matrice_creuse.Multiplication_S;

      --Variables

         poubelle : Integer; -- Pour lire une ligne du fichier net dans le vide
         i : Integer; -- Indice pour parcourir des listes
         indice : Integer;
         fichier : Ada.Text_IO.File_Type; --Fichier .net à lire
         Fichier_pr : Ada.Text_IO.File_Type; --Fichier .pr à créer
         Fichier_prw : Ada.Text_IO.File_Type; --Fichier .prw à créer
         depart : Integer; --Numéro site dé
         arrive : Integer;
         -- Valeur des cases des lignes vides
         valeur_cas_vide : Float;
         --Vecteurs poids
         pik : T_vecteur;
         pik_prec : T_vecteur;
         tri_pik : T_vecteur;
         --Vecteur page rank
         page_rank : T_vecteur;
         --Vecteur nombre de liaison
         nb_liaisons : T_vecteur;
         -- Matrices
         M_S : T_mat;
         -- Nom fichiers
         Nom_fichier_pr : Unbounded_String;
         Nom_fichier_prw : Unbounded_String;
   begin
      -- Passer une ligne dans la lecture du fichier (car nombre de site déja lu)
      open (fichier, In_File, To_String(nom_fichier_net));
      Get (fichier, poubelle);

      --Déterminer H grâce au fichier graphe
      Initialiser_matrice(nombre_site,nombre_site,M_S);
      Initialiser_vecteur(nombre_site,0.0,nb_liaisons);

      -- Calculer la matrice M_S (qui est en faite contenue dans la matrice M_S et le vecteur nb_liaisons)
      begin
         -- Tant qu'il y a encore des valeurs à lire
         while not End_Of_file (fichier) loop
            -- Lire les deux prochaines valeurs
            Get (fichier, depart);
            Get (fichier, arrive); 
            -- Mettre un 1 dans la matrice pour signifier le lien que si le lien n'a pas déja été créé
            if est_nul(Valeur(M_S,depart+1,arrive+1)) then
               Enregistrer(M_S,depart+1,arrive+1,1.0);
               nb_liaisons.tab(depart+1) := nb_liaisons.tab(depart+1) + 1.0;
            end if;
         end loop;
      exception
         when End_Error =>
            null;
         when Others =>
            raise erreur_lecture_fichier;
      end;
      Close (fichier);

      --Calculer le vecteur des poids
      Initialiser_vecteur(nombre_site,1.0/Float(nombre_site),pik);
      valeur_cas_vide := 1.0 / Float(nombre_site);
      i := 1;
      loop
         pik_prec := pik;
         -- Calculer le nouveau pik avec G (qui se déduit de M_S et nb_liaisons)
         pik := (alpha* Multiplication_S (pik,M_S,nb_liaisons,valeur_cas_vide)) + ((1.0-alpha)/Float(nombre_site)*somme(pik)) ;
         i := i + 1;
      exit when (i > k) or else distance(pik,pik_prec) < epsilon;
      end loop;

      --Détruction matrice S
      Detruire_mat(M_S);

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
end page_rank_matrice_creuse;