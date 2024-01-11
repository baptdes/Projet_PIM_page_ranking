with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Command_line;		use Ada.Command_line; -- Module pour lire les arguments de la commande
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with page_rank_matrice_creuse;
with page_rank_matrice_pleine;
with Ada.IO_Exceptions;

procedure page_rank is
   --Exceptions
      arguments_invalides : exception;
      No_Argument_Error : exception;
      alpha_hors_bornes : exception;
      k_negatif : exception;
      epsilon_negatif : exception;
      argument_inconnu : exception;
      nom_net_incorrect : exception;
   
   --Variables
      alpha : Float; --Valeur de alpha
      k : Integer;  -- Indice k du vecteur poids à calculer
      epsilon : Float; --Valeur de epsilon
      Prefix : Unbounded_String; -- Préfixe des fichiers résultats
      nom_fichier_net : Unbounded_String; -- Nom du fichier à lire
      Pleine : Boolean; -- Booleen pour choisir l’algorithme avec des matrices pleines (true) ou creuses (false)
      nombre_site : Integer; -- Nombre de sites dans le graphe
      fichier : Ada.Text_IO.File_Type; --Fichier .net à lire
      len : Integer; -- Longueur du nom du fichier net

   -- Procedures
      
      -- Traite les arguments et modifies les différentes variables si nécéssaire
      procedure Traiter_arguments(alpha : in out Float; k : in out Integer ; epsilon : in out Float ; Pleine : in out Boolean; Prefix : in out Unbounded_String; nom_fichier_net : out Unbounded_String) is
         i : Integer; -- Indice pour parcourir des listes
      begin
         i := 1;
         while (i<Argument_Count) loop
            begin
                  if Argument(i) = "-A" then
                     begin
                     alpha := float'Value(Argument(i+1));
                     i := i + 2;
                     if alpha < 0.0 or else alpha > 1.0 then
                        raise alpha_hors_bornes;
                     end if;
                     exception
                        when CONSTRAINT_ERROR => Put("Il manque la valeur de alpha après -A ou la valeur rentrée est incorrecte. Pour rappel, Alpha est un REEL entre 0 et 1"); raise arguments_invalides;
                        when alpha_hors_bornes => Put("Alpha doit être compris entre 0 et 1 au sens large"); raise arguments_invalides;
                     end;
                  elsif Argument(i) = "-K" then
                     begin
                     k := integer'Value(Argument(i+1));
                     i := i + 2;
                     if k < 0 then
                        raise k_negatif;
                     end if;
                     exception
                        when CONSTRAINT_ERROR => Put("Il manque la valeur de k après -K ou la valeur rentrée est incorrecte. Pour rappel, k est un ENTIER POSITIF"); raise arguments_invalides;
                        when k_negatif => Put("k négatif sérieusement ? k doit être un ENTIER POSITIF"); raise arguments_invalides;
                     end;
                  elsif Argument(i) = "-E" then
                     begin
                     epsilon := float'Value(Argument(i+1));
                     i := i + 2;
                     if epsilon < 0.0 then
                        raise epsilon_negatif;
                     end if;
                     exception
                        when CONSTRAINT_ERROR => Put("Il manque la valeur de epsilon après -E ou la valeur rentrée est incorrecte. Pour rappel, epsilon est un REEL POSITIF"); raise arguments_invalides;
                        when epsilon_negatif => Put("ça va être compliqué de faire le calcul avec une précison négative. Epsilon doit être POSITIF"); raise arguments_invalides;
                     end;
                  elsif Argument(i) = "-P" then
                     Pleine := True;
                     i := i + 1;
                  elsif Argument(i) = "-C" then
                     i := i + 1;
                  elsif Argument(i) = "-P" then
                     begin
                     Prefix := To_Unbounded_String(Argument(i+1));
                     i := i + 2;
                     exception
                        when CONSTRAINT_ERROR => Put("Il manque le préfixe des fichiers résulats après -P"); raise arguments_invalides;
                        when others => Put("Comment on est arrivé là ? (Problème après le -P)"); raise arguments_invalides;
                     end;
                  else
                     raise argument_inconnu;
                  end if;
            exception
               when argument_inconnu => Put("Il y a un argument qui n'est pas reconnu ou invalide"); raise arguments_invalides;
            end;
         end loop;
         begin
         nom_fichier_net := To_Unbounded_String(Argument(Argument_Count));
         len := Ada.Strings.Unbounded.Length(nom_fichier_net);
         if Ada.Strings.Unbounded.Slice(nom_fichier_net, Len - 3, Len) /= To_Unbounded_String(".net") then
            raise nom_net_incorrect;
         end if;
         exception
            when nom_net_incorrect => Put("Le nom du fichier .net ne porte pas la bonne extension (.net) ou est absent"); raise arguments_invalides;
            when CONSTRAINT_ERROR => Put("Le nom du fichier .net est absent"); raise arguments_invalides;
         end;
      end Traiter_arguments;
begin
   
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
   Traiter_arguments(alpha, k, epsilon, Pleine, Prefix, nom_fichier_net);

   --Lecture du nombre de site
   open (fichier, In_File, To_String(nom_fichier_net));
   Get (fichier, nombre_site);
   Close (fichier);

   -- Appeler le programme qui correspond au choix de l'utilisateur
    if Pleine then
        page_rank_matrice_pleine.page_rank(nombre_site,alpha,k,epsilon,Prefix,nom_fichier_net);
    else
        page_rank_matrice_creuse.page_rank(nombre_site,alpha,k,epsilon,Prefix,nom_fichier_net);
    end if;

exception
   when arguments_invalides => Null;
   when No_Argument_Error => Put_Line("Si vous voulez un résultat, il est préférable d'indiquer au moins le nom du fichier .net :)");
   when ADA.IO_EXCEPTIONS.NAME_ERROR => Put_Line("Le fichier "&To_String(nom_fichier_net)&" n'existe pas");
   when page_rank_matrice_pleine.erreur_lecture_fichier | ADA.IO_EXCEPTIONS.DATA_ERROR => Put_Line("Le fichier "& To_String(nom_fichier_net) & " est incorrect (erreur de lecture)");
end page_rank;