with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;	use Ada.Integer_Text_IO;
with Ada.Command_line;		use Ada.Command_line; -- Module pour lire les arguments de la commande
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with page_rank_matrice_creuse;
with page_rank_matrice_pleine;

procedure page_rank is
   --Exceptions
      arguments_invalides : exception;
      No_Argument_Error : exception;
   
   --Variables
      alpha : Float; --Valeur de alpha
      k : Integer;  -- Indice k du vecteur poids à calculer
      epsilon : Float; --Valeur de epsilon
      Prefix : Unbounded_String; -- Préfixe des fichiers résultats
      nom_fichier_net : Unbounded_String; -- Nom du fichier à lire
      Pleine : Boolean; -- Booleen pour choisir l’algorithme avec des matrices pleines (true) ou creuses (false)
      nombre_site : Integer; -- Nombre de sites dans le graphe
      fichier : Ada.Text_IO.File_Type; --Fichier .net à lire

      -- Procedures
      procedure Traiter_arguments(alpha : in out Float; k : in out Integer ; epsilon : in out Float ; Pleine : in out Boolean; Prefix : in out Unbounded_String; nom_fichier_net : out Unbounded_String) is
         i : Integer; -- Indice pour parcourir des listes
      begin
         i := 1;
         while (i<Argument_Count) loop
            begin
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
         nom_fichier_net := To_Unbounded_String(Argument(Argument_Count));
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

end page_rank;