generic
    Capacite: Integer; -- Capacité des vecteurs

    type T_Valeur is private;
    
    with function "+" (Left, Right : T_valeur) return T_valeur is <>;
    with function "-" (Left, Right : T_valeur) return T_valeur is <>;
    with function "*" (Left, Right : T_valeur) return T_valeur is <>;
package Vecteurs is
    --Exceptions
    Taille_Differente : exception;

    -- Type d'un vecteur
    type T_Tab is array(1..Capacite) of T_valeur;
    type T_vecteur is
        record  
            longueur : Integer;
            tab : T_Tab;
        end record;

    -- Initialisation d'un vecteur : 

        -- Initialise un vecteur à la taille l
        procedure Initialiser_vecteur(l : in Integer; x:in T_valeur; V : out T_vecteur);

    --Opérations de bases sur des vecteurs : 

        --Multiplication d'un vecteur par un scalaire
        function "*" (lambda:in T_valeur ; V:in T_vecteur) return T_vecteur;

        --Addition de deux vecteurs.
        --Renvoie l'exception Taille_Differente si les tailles ne correspondent pas
        function "+" (V1, V2: in T_vecteur) return T_vecteur;

        --Somme d'un vecteur avec une valeur (on ajoute cette valeur à chaque valeurs du vecteurs)
        function "+"(V:in T_vecteur; x : in T_Valeur) return T_vecteur;

    -- Calculs/tri sur des vecteurs : 

        -- Renvoie le max d'un vecteur
        generic
            with function ">=" (Left, Right : T_valeur) return Boolean is <>;
        function max(V:in T_vecteur) return integer;

        -- Somme les termes d'un vecteur
        function somme(V:in T_vecteur) return T_valeur;

        --Renvoie la distance entre deux vecteurs d'une matrice colonne
        --Renvoie l'exception Taille_Differente si les tailles ne correspondent pas
        generic
            with function sqrt (x : T_Valeur) return T_Valeur is <>;
        function distance (V1 : in T_vecteur;V2 : in T_vecteur) return T_valeur;

end Vecteurs;