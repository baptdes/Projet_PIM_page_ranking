package body Matrice is
    
    procedure Initialiser(l:in Integer; c:in Integer; x:in Float; M:out T_mat) is
    begin
        --Si la taille est en dehors de la capacité on léve une exception
        if l > Capacite or c > Capacite then
            raise Taille_Hors_Capacite;
        else
            for i in 1..l loop
                for j in 1..c loop
                    M.Mat(i,j) := x;
                end loop;
            end loop;
            M.nombre_colonne := c;
            M.nombre_ligne := l;
        end if;
    end Initialiser;
    
    
    function Ligne_Vide (M :in T_mat; l:in Integer) is
    begin
        for i in 1..M.nombre_colonne loop
            if M.Mat(l,i) = 0 then
                none;
            else
                return False;
            end if;
        end loop;
        return True;
    end Ligne_vide;
    
    
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float) is
    begin
        if ligne > 0 and ligne < M.nombre_ligne and colonne > 0 and colonne < M.nombre_colonne then
            M.Mat(ligne,colonne) := valeur;
        else
            raise Case_Hors_Bornes;
        end if;
    end Enregistrer;    
    
    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float) is
    begin
        if ligne > 0 and ligne < M.nombre_ligne then
            for i in 1..M.nombre_colonne loop
                M.Mat(ligne,i) := valeur;
            end loop;
        else
            raise Ligne_Hors_Bornes;
        end if;                
    end Modifier_ligne;
    
    
    function Ligne_max(M:in T_mat) is
        maximum: Integer;
    begin
        if M.nombre_colonne = 1 then
            maximum := 0;
            for i in 1..M.nombre_ligne loop
                if M.Mat(i,1) >= maximum then
                    maximum := M.Mat(i,1);
                else
                    none;
                end if;
            end loop;
            return maximum;
        else
            raise Maximum_Indeterminable;
        end if;                
    end Ligne_max;    
    
    
    function Addition(M1:in T_mat; M2:in T_mat) is
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
    end Addition;
    
    
    function Multiplication(M1:in T_mat; M2:in T_mat) is
        Produit: T_mat;
        s: Integer;
    begin
        if M1.nombre_colonne = M2.nombre_ligne then
            Produit.nombre_ligne := M1.nombre_ligne;
            Produit.nombre_colonne := M2.nombre_colonne;
            for i in 1..Produit.nombre_ligne loop
                for j in 1..Produit.nombre_colonne loop
                    s := 0;
                    for k in 1..M1.nombre_colonne loop
                        s := s + M1(i,k)*M2(k,j);
                    end loop;
                    Produit(i,j) := s;
                end loop;
            end loop;
            return Produit;
        else
            raise Taille_Incompatible_Multiplication;
        end if;                        
    end Multiplication;
    
    
    function Transpose(M:in T_mat) is
        T : T_mat;
    begin
        T.nombre_colonne := M.nombre_ligne;
        T.nombre_ligne := M.nombre_colonne;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                T.Mat(j,i) := M.Mat(i,j);
            end loop;
        end loop;
    end Transpose;
    
    
    function Module(M:in T_mat) is
        module: Integer;
    begin
        if M.nombre_colonne = 1 then
            module := 0;
            for i in 1..M.nombre_ligne loop
                module := module + M.Mat(i,1);
            end loop;
        else
            raise Module_Indeterminable;
        end if;
    end Module;
        
end Matrice;
