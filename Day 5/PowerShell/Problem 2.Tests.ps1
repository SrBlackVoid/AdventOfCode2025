Describe "SolveProblem2" {
	BeforeAll {
		$source = ".\Problem 2.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem2 -InputPath $inputPath -Verbose -Debug

		$result | Should -Be 14
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
