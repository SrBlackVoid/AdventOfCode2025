Describe "SolveProblem1" {
	BeforeAll {
		$source = ".\Problem 1.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem1 -InputPath $inputPath

		$result | Should -Be 21
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
