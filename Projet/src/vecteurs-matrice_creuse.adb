package body vecteurs.Matrice_creuse is

    -- Fonction de hachage pour le module TH

        function Fonction_hachage(taille: in Integer; Cle1: in Integer; Cle2: in Integer) return Integer is
        begin
            return (Cle1 + Cle2) mod taille + 1;
        end Fonction_hachage;

    -- Fonctions et procedures de bases pour T_Mat

        function nb_lignes(M : T_Mat) return Integer is
        begin
            return M.nombre_ligne;
        end;

        function nb_colones(M : T_Mat) return Integer is
        begin
            return M.nombre_ligne;
        end;

        procedure Initialiser_matrice(l:in Integer; c:in Integer; M:out T_mat) is
        begin
            -- On vérifie que l'on se trouve dans les bornes de la matrice
            M.nombre_colonne := c;
            M.nombre_ligne := l;
            Hachage.Initialiser(M.Mat);
        end Initialiser_matrice;

        procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in T_valeur) is
        begin
            -- Dans le cas d'une matrice creuse, si la valeur est 0, c'est que l'on veut supprimer la clé du tableau
            -- de hachage
            if est_nul(valeur) then
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

        function Valeur(M : in T_mat; i : in Integer; j : in Integer) return T_valeur is
            Out_of_bounds : exception;
        begin
            -- Si les indices dépassent les bornes ont lève une exception
            if i > M.nombre_ligne or j > M.nombre_colonne then
                raise Out_of_bounds;
            else
                -- On regarde si la clé est présente et si c'est le cas ont retourne la valeur associé sinon 0.0
                if Hachage.Cle_Presente(M.Mat, i, j) then
                    return Hachage.La_Valeur(M.Mat,i,j);
                else
                    return zero;
                end if;
            end if;
        end Valeur;

        procedure Detruire_mat (M :  in out T_Mat) is
        begin
            Detruire(M.Mat);
        end Detruire_mat;

    -- Opérations de bases sur des matrices
    
        function "+" (M1, M2: in T_mat) return T_mat is
        S : T_mat; -- S la matrice Somme
        val : T_valeur; -- Valeur de la case (i,j)
        begin
            if M1.nombre_colonne = M2.nombre_colonne and M1.nombre_ligne = M2.nombre_ligne then
                S.nombre_colonne := M1.nombre_colonne;
                S.nombre_ligne := M1.nombre_ligne;
                for i in 1..S.nombre_ligne loop
                    for j in 1..S.nombre_colonne loop
                        val := Valeur(M1,i,j) + Valeur(M2,i,j);
                        Enregistrer(S.Mat,i,j,Val);
                    end loop;
                end loop;
            -- Si les tailles de matrices ne sont pas les mêmes, alors on léve l'exception
            else
                raise Taille_Differente_Addition;
            end if;
            return S;
        end "+";

        --Multiplication de deux matrices
        function "*" (M1, M2 : in T_mat) return T_mat is
            Produit: T_mat;
            s: T_valeur;
        begin
            if M1.nombre_colonne = M2.nombre_ligne then
                Produit.nombre_ligne := M1.nombre_ligne;
                Produit.nombre_colonne := M2.nombre_colonne;
                for i in 1..Produit.nombre_ligne loop
                    for j in 1..Produit.nombre_colonne loop
                        s := zero;
                        for k in 1..M1.nombre_colonne loop
                            s := s + Valeur(M1,i,k)*Valeur(M2,k,j);
                        end loop;
                        Enregistrer(Produit.Mat,i,j,s);
                    end loop;
                end loop;
                return Produit;
            else
                raise Taille_Incompatible_Multiplication;
            end if;
        end "*";
        
        --Multiplication d'une matrice par un scalaire
        function "*" (lambda:in T_valeur ; M:in T_mat) return T_mat is
            T : T_mat;
        begin
            T.nombre_colonne := M.nombre_colonne;
            T.nombre_ligne := M.nombre_ligne;
            for i in 1..M.nombre_ligne loop
                for j in 1..M.nombre_colonne loop
                    Enregistrer(T,i,j,lambda * valeur(M,i,j));
                end loop;
            end loop;
            return T;
        end "*";

    -- Opérations entre vecteurs et matrices
    
        function Multiplication_S (V : in T_vecteur; M : in T_mat; nb_liaisons : in T_vecteur; valeur_cas_vide : in T_Valeur) return T_vecteur is

            Produit: T_vecteur;

            procedure Traiter_elem (Couple : T_Couple; Valeur: in T_valeur) is
                i : Integer;
                j : integer;
            begin
                i := Couple.Cle_1;
                j := Couple.Cle_2;
                Produit.tab(j) := Produit.tab(j) + V.tab(i)*(Valeur/nb_liaisons.tab(i));
            end Traiter_elem;
            
            procedure traiter_TH is new
                    hachage.Pour_Chaque(Traitement => Traiter_elem);
        begin
            Initialiser_vecteur(M.nombre_colonne,zero,produit);
            if V.longueur = M.nombre_ligne then
                traiter_TH(M.Mat);
                for i in 1..nb_liaisons.longueur loop
                    if est_nul(nb_liaisons.tab(i)) then
                        for j in 1..nb_liaisons.longueur loop
                            Produit.tab(j) := Produit.tab(j) + V.tab(i)*valeur_cas_vide;
                        end loop;
                    end if;
                end loop;
                return Produit;
            else
                raise Taille_Incompatible_Multiplication;
            end if;
        end Multiplication_S;

end vecteurs.Matrice_creuse;

-- Architecture
-- Proportion de travail
-- Nombres d'heures passé