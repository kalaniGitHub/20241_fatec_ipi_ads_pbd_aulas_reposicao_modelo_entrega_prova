-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui
CREATE TABLE study_prediction (
    studentid SERIAL PRIMARY KEY,
    salary VARCHAR(10),
    MOTHER_EDU VARCHAR(10),
    FATHER_EDU VARCHAR(10),
    grade VARCHAR(10),
    PREP_EXAM VARCHAR(10)
);
COPY study_prediction TO 'C:\Users\aluno\Downloads\archive' WITH (FORMAT CSV, HEADER);



-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui
DECLARE cur_parent_edu CURSOR FOR
SELECT COUNT(*)
FROM study_prediction
WHERE (MOTHER_EDU = 'Ph.D.' OR FATHER_EDU = 'Ph.D.') AND grade IN ('AA', 'BA', 'BB', 'CB');


-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui
DO $$
DECLARE
    student_count INTEGER;
BEGIN
    EXECUTE 'SELECT COUNT(*) FROM study_prediction WHERE PREP_EXAM = ''alone'' AND grade IN (''AA'', ''BA'', ''BB'', ''CB'')' INTO student_count;
    IF student_count = 0 THEN
        RAISE NOTICE '-1';
    ELSE
        RAISE NOTICE '%', student_count;
    END IF;
END $$;



-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui
DECLARE cur_salary_study CURSOR FOR
SELECT COUNT(*)
FROM study_prediction
WHERE salary > '410' AND PREP_EXAM = 'regularly';


-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN (SELECT * FROM study_prediction WHERE salary IS NULL OR MOTHER_EDU IS NULL OR FATHER_EDU IS NULL OR grade IS NULL OR PREP_EXAM IS NULL) 
    LOOP
        RAISE NOTICE 'Tupla com NULL: %', rec;
        DELETE FROM study_prediction WHERE studentid = rec.studentid;
    END LOOP;
    
    FOR rec IN (SELECT * FROM study_prediction ORDER BY studentid DESC) LOOP
        RAISE NOTICE 'Tupla remanescente: %', rec;
    END LOOP;
END $$;

-- ----------------------------------------------------------------