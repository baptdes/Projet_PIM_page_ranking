with Ada.Text_IO;			use Ada.Text_IO;

package body vecteurs.matrice_pleine is
    
    -- Fonctions et procedures de bases pour une matrice

        procedure Initialiser_matrice(l:in Integer; c:in Integer; x:in T_valeur; M:out T_mat) is
        begin
            for i in 1..l loop
                for j in 1..c loop
                    M.Mat(i,j) := x;
                end loop;
            end loop;
            M.nombre_colonne := c;
            M.nombre_ligne := l;
        end Initialiser_matrice;

        function nb_lignes(M : T_Mat) return Integer is
        begin
            return M.nombre_ligne;
        end;

        function nb_colones(M : T_Mat) return Integer is
        begin
            return M.nombre_ligne;
        end;
    
        procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in T_valeur) is
        begin
            if ligne > 0 and ligne < M.nombre_ligne and colonne > 0 and colonne < M.nombre_colonne then
                M.Mat(ligne,colonne) := valeur;
            else
                raise Case_Hors_Bornes;
            end if;
        end Enregistrer;

        procedure Afficher (M : in T_mat) is
        begin
            New_Line;
            for i in 1..M.nombre_ligne loop
                for j in 1..M.nombre_colonne loop
                    Put (M.Mat(i, j));
                    Put(" ");
                end loop;
                New_Line;
            end loop;
        end Afficher;

    -- Opérations pour des matrices
    
        function "+" (M1,M2 : in T_mat) return T_mat is
            Somme: T_mat;
        begin
            
            if M1.nombre_colonne = M2.nombre_colonne and M1.nombre_ligne = M2.nombre_ligne then
                Somme.nombre_colonne := M1.nombre_colonne;
                Somme.nombre_ligne := M2.nombre_ligne;
                for i in 1..M1.nombre_ligne loop
                    for j in 1..M2.nombre_colonne loop
                        Somme.Mat(i,j) := M1.Mat(i,j) + M2.Mat(i,j);
                    end loop;
                end loop;
                return Somme;
            else
                raise Taille_Differente_Addition;
            end if;   
        end "+";

        -- Multiplication entre deux matrices
        function "*" (M1,M2:in T_mat) return T_mat is
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
                            s := s + M1.Mat(i,k)*M2.Mat(k,j);
                        end loop;
                        Produit.Mat(i,j) := s;
                    end loop;
                end loop;
                return Produit;
            else
                raise Taille_Incompatible_Multiplication;
            end if;                        
        end "*";
        
        -- Multiplication entre une valeur et une matrice
        function "*" (lambda:in T_valeur ; M:in T_mat) return T_mat is
            T : T_mat;
        begin
            T.nombre_colonne := M.nombre_colonne;
            T.nombre_ligne := M.nombre_ligne;
            for i in 1..M.nombre_ligne loop
                for j in 1..M.nombre_colonne loop
                    T.mat(i,j) := lambda * M.mat(i,j);
                end loop;
            end loop;
            return T;
        end "*";

        procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in T_valeur) is
        begin
            if ligne > 0 and ligne < M.nombre_ligne then
                for i in 1..M.nombre_colonne loop
                    M.Mat(ligne,i) := valeur;
                end loop;
            else
                raise Ligne_Hors_Bornes;
            end if;                
        end Modifier_ligne;

        function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean is
            res : Boolean;
        begin 
            res := True;
            for j in 1..M.nombre_colonne loop
                if not est_nul(M.Mat(l,j)) then
                    res := False;
                else
                    Null;
                end if;
            end loop;
            return res;
        end Ligne_Vide;

    -- Opérations entre des vceteurs et des matrices

        function "*" (V : in T_vecteur; M : in T_mat) return T_vecteur is
            Produit: T_vecteur;
            s: T_valeur;
        begin
            Produit.longueur := M.nombre_colonne;
            if V.longueur = M.nombre_ligne then
                for j in 1..Produit.longueur loop
                    s := zero;
                    for k in 1..M.nombre_ligne loop
                        s := s + V.tab(k)*M.Mat(k,j);
                    end loop;
                    Produit.Tab(j) := s;
                end loop;
                return Produit;
            else
                raise Taille_Incompatible_Multiplication;
            end if;
        end "*";

end vecteurs.matrice_pleine;