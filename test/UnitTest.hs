module UnitTest where

type TestName = String
type TestResult = Either String ()

data Test = Test TestName TestResult

assertEquals :: (Eq a, Show a) => TestName -> a -> a -> Test
assertEquals name expected actual =
  Test name $
    if expected == actual
      then Right ()
      else Left ("Esperava " ++ show expected ++ ", recebeu " ++ show actual)

assertTrue :: TestName -> Bool -> String -> Test
assertTrue name condition msg =
  Test name $
    if condition then Right () else Left msg

assertRight :: (Show e, Show a) => TestName -> Either e a -> Test
assertRight name result =
  case result of
    Left e ->
      Test
        (name ++ " | retorno: " ++ show e)
        (Left "Esperava sucesso, mas falhou")
    Right v ->
      Test
        (name ++ " | retorno: " ++ show v)
        (Right ())

assertLeft :: (Show e, Show a) => TestName -> Either e a -> Test
assertLeft name result =
  case result of
    Left e ->
      Test 
        (name ++ " | retorno: " ++ show e)
        (Right ())
    Right v ->
      Test
        name
        (Left ("Esperava falha, mas retornou: " ++ show v))

runTest :: Test -> IO Bool
runTest (Test name result) = do
  case result of
    Right () -> do
      putStrLn ("[PASS] " ++ name)
      return True
    Left err -> do
      putStrLn ("[FAIL] " ++ name)
      putStrLn ("       " ++ err)
      return False

class TestSuite a where
  tests :: a -> [Test]

runTests :: [Test] -> IO ()
runTests ts = do
  results <- mapM runTest ts
  let passed = length (filter id results)
      total = length results
  putStrLn (show passed ++ "/" ++ show total ++ " tests passed")

runSuite :: TestSuite a => a -> IO ()
runSuite suite = runTests (tests suite)