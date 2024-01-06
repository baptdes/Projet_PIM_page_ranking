package body matrice_creuse is
    
    procedure Initialiser_matrice(l:in Integer; c:in Integer; M:out T_mat) is
    begin
        -- On vérifie que l'on se trouve dans les bornes de la matrice
        if l < Capacite and l > 0 and c < Capacite and c > 0 then
            M.nombre_colonne := c;
            M.nombre_ligne := l;
            Hachage.Initialiser(M.Mat);
        else
            raise Taille_Hors_Capacite;
        end if;
    end Initialiser_matrice;
        
    --Est-ce que la ligne "ligne" dans la matrice M est vide ?
    --Renvoie l'exception Ligne_Hors_Bornes si ligne>nombre_ligne
    function Ligne_Vide (M :in T_mat; l:in Integer) is
    begin
        if M.nombre_ligne >= l then
            for i in 1..M.nombre_colonne loop
                --On vérifie si le couple ligne l colone i existe dans le tableau où non
                if Hachage.Cle_Presente(M.Mat, l, i) then
                    return False;
                end if;
            end loop;
            -- Si le programme ne trouve aucune valeur pour la ligne, alors c'est que c'est bien vide.
            return True;
        else
            -- on léve l'exception si l > M.nombre_ligne
            raise Ligne_Hors_Bornes;
        end if;
    end Ligne_Vide;            
    
    --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
    --Renvoie l'Excepetion Case_Hors_Bornes si ligne > M.nombre_ligne ou si colonne > M.nombre_colonne
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float) is
    begin
        --dans le cas d'une matrice creuse, si la valeur est 0, c'est que l'on veut supprimer la clé du tableau
        --de hachage
        if valeur = 0 then
            -- est-ce que la valeur était différente de 0 avant ? Ce qui revient à demander si la clé est présente dans
            -- notre tableau de hachage ou non
            if Hachage.Cle_Presente(M.Mat, ligne, colonne) then
                -- on supprime la clé (ligne,colonne) du tableau ce qui revient à un mise à 0
                Hachage.Supprimer(M.Mat,ligne,colonne);
            else
                -- Si la valeur était déjà à 0, on ne fais rien
                null;
            end if;
        -- si la valeur n'est pas de 0, on modifie quoi qu'il arrive le tableau de hachage
        else
            Hachage.Enregistrer(M.Mat,ligne,colonne,valeur);
        end if;
    end Enregistrer;
    
    
    --Modifier toute une ligne d'une matrice M
    --Renvoie l'exception Ligne_Hors_Bornes si ligne > M.nombre_ligne    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float) is
    begin
        if ligne <= M.nombre_ligne then
            for i in 1..M.nombre_colonne loop
                Enregistrer(M.Mat, ligne, i, valeur);
            end loop;
        else
            raise Ligne_Hors_Bornes;
        end if;
    end Modifier_ligne;
    
    --Addition de deux matrices.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function "+" (M1, M2: in T_mat) is
    S : T_mat; -- S la matrice Somme
    begin
        if M1.nombre_colonne = M2.nombre_colonne and M1.nombre_ligne = M2.nombre_ligne then
            S.nombre_colonne := M1.nombre_colonne;
            S.nombre_ligne := M1.nombre_ligne;
            for i in 1..S.nombre_ligne loop
                for j in 1..S.nombre_colonne loop
                    -- Si les deux matrices ont des valeurs différentes de 0 en i,j, on met dans S(i,j) la somme des deux
                    if Hachage.Cle_Presente(M1.Mat, i, j) and Hachage.Cle_Presente(M2.Mat, i, j) then
                        Enregistrer(S.Mat,i,j,(Hachage.La_Valeur(M1.Mat,i,j)+Hachage.La_Valeur(M2.Mat,i,j)));
                    elsif Hachage.Cle_Presente(M1.Mat, i, j) then --Si la premiére matrice à une valeur en i,j on la met dans S
                        Enregistrer(S.Mat,i,j,Hachage.La_Valeur(M1.Mat,i,j));
                    elsif Hachage.Cle_Presente(M2.Mat, i, j) then --Si la deuxiemme matrice à une valeur en i,j on la met dans S
                        Enregistrer(S.Mat,i,j,Hachage.La_Valeur(M2.Mat,i,j));
                    else -- Sinon, c'est que aucune des matrice n'a de valeur autre que 0 en i,j auquel cas, on laisse S(i,j) à 0
                        null;
                    end if;
                end loop;
            end loop;
        -- Si les tailles de matrices ne sont pas les mêmes, alors on léve l'exception
        else
            raise Taille_Differente_Addition;
        end "+";
                                    
                                        

    --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function "*" (M1, M2 : in T_mat) return T_mat;
    
    
    --Renvoyer la transposé d'une matrice
    function Transpose(M:in T_mat) return T_mat;
            --Post => Transpose'Result.nombre_ligne = M.nombre_colonne
            --and Transpose'Result.nombre_colonne = M.nombre_ligne
    
    --Multiplication d'une matrice par un scalaire
    function "*" (lambda:in float ; M:in T_mat) return T_mat;

    --Multiplication d'un vecteur par un scalaire
    function "*" (lambda:in float ; V:in T_vecteur) return T_vecteur;

    procedure Quicksort(V: in out T_vecteur; bas, haut: Integer; Indices_tries : out T_vecteur);

    procedure Afficher (M : in T_mat);

    function Ligne_max(V:in T_vecteur) return integer;

   

end matrice_creuse;
