with TH;

generic
    Taille: Integer; --Nombre de cases dans le tableau de hachage
    zero : T_valeur;
    with function est_nul(x : T_Valeur) return Boolean;
package vecteurs.Matrice_creuse is
    
    --Exceptions
        Case_Hors_Bornes : exception;
        Ligne_Hors_Bornes : exception;
        Taille_Differente_Addition: exception;
        Taille_Incompatible_Multiplication: exception;
        Maximum_Indeterminable: exception;
        Module_Indeterminable: exception;
    
    --Importation du module TH (table de hachage)
        
        -- Fonction de hachage pour le module TH
        function Fonction_hachage(taille: in Integer; Cle1: in Integer; Cle2: in Integer) return Integer;
            
        package Hachage is 
            new TH(Capacite => Taille, T_Cle => Integer, T_Valeur => T_valeur, fonction_hachage => Fonction_hachage);
        use Hachage;

    type T_Mat is private;

    -- Fonctions et procedures de bases pour T_Mat

        --Renvoie le nombre de lignes
        function nb_lignes(M : T_Mat) return Integer;

        --Renvoie le nombre de colones
        function nb_colones(M : T_Mat) return Integer;
        
        --Initialiser une matrice de taille l * c creuse (aucune valeur présente au début)
        --On léve l'exception Taille_Hors_Capacite si la taille demandé dépasse les capacités
        procedure Initialiser_matrice(l:in Integer; c:in Integer; M:out T_mat);

        --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
        --Renvoie l'Excepetion Case_Hors_Bornes si ligne > M.nombre_ligne ou si colonne > M.nombre_colonne
        procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in T_valeur);

        -- Récupère la valeur d'une case (i,j) et renvoie 0 si la case n'existe pas
        -- Exception levé si i et j hors bornes
        function Valeur(M : in T_mat; i : in Integer; j : in Integer) return T_valeur;

        -- Détruire une matrice
        procedure Detruire_mat (M :  in out T_Mat);

    -- Opérations de bases sur des matrices

        --Addition de deux matrices.
        --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
        function "+" (M1, M2: in T_mat) return T_mat;

        --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
        --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
        function "*" (M1, M2 : in T_mat) return T_mat;

        --Multiplication d'une matrice par un scalaire
        function "*" (lambda:in T_valeur ; M:in T_mat) return T_mat;
    
    -- Opérations entre vecteurs et matrices

        -- Multiplication de pikT avec M_S (qui est en fait contenue dans M et nb_liaisons)
        generic
            with function "/" (Left, Right : T_valeur) return T_valeur is <>;
        function Multiplication_S (V : in T_vecteur; M : in T_mat; nb_liaisons : in T_vecteur; valeur_cas_vide : in T_Valeur) return T_vecteur;

private
    type T_mat is
        record
            nombre_ligne: Integer;
            nombre_colonne: Integer;
            Mat: T_TH;
        end record;
end vecteurs.Matrice_creuse;
