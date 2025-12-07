Describe "SolveProblem2" {
	BeforeAll {
		$source = ".\Problem 2.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem2 -InputPath $inputPath

		$result | Should -Be 40
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
