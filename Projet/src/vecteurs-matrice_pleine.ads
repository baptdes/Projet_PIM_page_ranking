generic
    Capacite: Integer;
    zero : T_Valeur;
    with function est_nul(x : T_Valeur) return Boolean;
package vecteurs.matrice_pleine is
    
    --Exceptions
        Taille_Hors_Capacite : exception;
        Case_Hors_Bornes : exception;
        Ligne_Hors_Bornes : exception;
        Taille_Differente_Addition: exception;
        Taille_Incompatible_Multiplication: exception;
        Maximum_Indeterminable: exception;
        Module_Indeterminable: exception;
    
    -- Type matrice (pleine)
        type T_Matrice is array(1..Capacite,1..Capacite) of T_valeur;
        type T_mat is
            record
                nombre_ligne: Integer;
                nombre_colonne: Integer;
                Mat: T_Matrice;
            end record;
    
    -- Fonctions et procedures de bases pour une matrice

        --Initialiser une matrice de taille l * c remplie de x
        --On léve l'eception Taille_Hors_Capacite si la taille demandée dépasse les capacités
        procedure Initialiser_matrice(l:in Integer; c:in Integer; x:in T_Valeur; M:out T_mat);

        function nb_lignes(M : T_Mat) return Integer;

        function nb_colones(M : T_Mat) return Integer;
        
        --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
        --Renvoie l'Excepetion Case_Hors_Bornes si ligne > M.nombre_ligne ou si colonne > M.nombre_colonne
        procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in T_Valeur);

        -- Affiche une matrice
        generic
            with procedure Put(x : in T_Valeur);
        procedure Afficher (M : in T_mat);
    
    -- Opérations pour des matrices

        --Addition de deux matrices.
        --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
        function "+" (M1, M2: in T_mat) return T_mat;

        --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
        --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
        function "*" (M1, M2 : in T_mat) return T_mat;

        --Multiplication d'une matrice par un scalaire
        function "*" (lambda:in T_valeur ; M:in T_mat) return T_mat;

        --Modifier toute une ligne d'une matrice M
        --Renvoie l'exception Ligne_Hors_Bornes si ligne > M.nombre_ligne    
        procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in T_valeur);

        --Est-ce que la ligne "ligne" dans la matrice M est vide ?
        --Renvoie l'exception Ligne_Hors_Bornes si ligne>nombre_ligne
        function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean;
    
    --Opérations entre des vceteurs et des matrices

        --Multiplication d'un vecteur par une matrice (le vecteur M1 est mis en colone pour être multiplier comme une matrice par M)
        --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
        function "*" (V : in T_vecteur; M : in T_mat) return T_vecteur;

end vecteurs.matrice_pleine;