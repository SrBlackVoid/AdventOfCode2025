Describe "ReworkNumbers" {
	BeforeAll {
		. ".\Problem 2.ps1"
	}

	Context "Even-Length Inputs" {
		It "Handles 2-digit numbers" {
			$testInput = @(
				"12"
				"34"
			)
			$result = ReworkNumbers -Numbers $testInput -MaxLength 2
			$result | Should -BeExactly @(24,13)
		}

		It "Handles 3-digit numbers" {
			$testInput = @(
				"123"
				"456"
			)
			$result = ReworkNumbers -Numbers $testInput -MaxLength 3
			$result | Should -BeExactly @(36,25,14)
		}
	}

	Context "Uneven-Length Inputs" {
		Context "1 digit difference" {
			Context "Alignment" {
				It "Handles when aligned to the left" {
					$testInput = @(
						"12"
						"3 "
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 2
					$result | Should -BeExactly @(2,13)
				}

				It "Handles when aligned to the right" {
					$testInput = @(
						"12"
						" 3"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 2
					$result | Should -BeExactly @(23,1)
				}
			}

			Context "Order of Larger Number" {
				It "Handles when larger number is on top" {
					$testInput = @(
						"12"
						"3 "
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 2
					$result | Should -BeExactly @(2,13)
				}

				It "Handles when larger number is on bottom" {
					$testInput = @(
						"3 "
						"12"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 2
					$result | Should -BeExactly @(2,31)
				}
			}
		}

		Context "2 or more digit difference" {
			Context "Alignment" {
				It "Handles when aligned to the left" {
					$testInput = @(
						"1  "
						"345"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 3
					$result | Should -BeExactly @(5,4,13)
				}

				It "Handles when aligned to the right" {
					$testInput = @(
						"  1"
						"345"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 3
					$result | Should -BeExactly @(15,4,3)
				}
			}

			Context "Order of Larger Number" {
				It "Handles when larger number is on top" {
					$testInput = @(
						"345"
						"1  "
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 3
					$result | Should -BeExactly @(5,4,31)
				}

				It "Handles when larger number is on bottom" {
					$testInput = @(
						"1  "
						"345"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 3
					$result | Should -BeExactly @(5,4,13)
				}
			}
		}

		Context "Smaller Number in Middle" -Tag "Debug" {
			Context "Alignment" {
				It "Handles when aligned to the left" {
					$testInput = @(
						"345"
						"1  "
						"678"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 3
					$result | Should -BeExactly @(58,47,316)
				}

				It "Handles when aligned to the right" {
					$testInput = @(
						"345"
						"  1"
						"678"
					)
					$result = ReworkNumbers -Numbers $testInput -MaxLength 3
					$result | Should -BeExactly @(518,47,36)
				}
			}
		}
	}

	Context "Demo examples" {
		It "Handles the column '64 ,23, 314'" {
			$testInput = @(
				"64 "
				"23 "
				"314"
			)
			$result = ReworkNumbers -Numbers $testInput -MaxLength 3
			$result | Should -BeExactly @(4,431,623)
		}

		It "Handles the column ' 51,387,215'" {
			$testInput = @(
				" 51"
				"387"
				"215"
			)
			$result = ReworkNumbers -Numbers $testInput -MaxLength 3
			$result | Should -BeExactly @(175,581,32)
		}

		It "Handles the column '328,64 ,98 " {
			$testInput = @(
				"328"
				"64 "
				"98 "
			)
			$result = ReworkNumbers -Numbers $testInput -MaxLength 3
			$result | Should -BeExactly @(8,248,369)
		}

		It "Handles the column '123,45 ,6  '" {
			$testInput = @(
				"123"
				" 45"
				"  6"
			)
			$result = ReworkNumbers -Numbers $testInput -MaxLength 3
			$result | Should -BeExactly @(356,24,1)
		}
	}
}

Describe "SolveColumnProblem" {
	BeforeAll {
		. ".\Problem 2.ps1"
	}
	
	Context "Basic Math" {
		It "Correctly solves addition problems" {
			$numbers = @(12,34,56)
			$operator = "+"
			$result = SolveColumnProblem -Numbers $numbers -Operator $operator
			$result | Should -Be 102
		}

		It "Correctly solves multiplication problems" {
			$numbers = @(2,3,4)
			$operator = "*"
			$result = SolveColumnProblem -Numbers $numbers -Operator $operator
			$result | Should -Be 24
		}
	}


	Context "Demo Examples" {
		It "Solves 4 + 431 + 623" {
			$numbers = @(4,431,623)
			$operator = "+"
			$result = SolveColumnProblem -Numbers $numbers -Operator $operator
			$result | Should -Be 1058
		}

		It "Solves 175 * 581 * 32" {
			$numbers = @(175,581,32)
			$operator = "*"
			$result = SolveColumnProblem -Numbers $numbers -Operator $operator
			$result | Should -Be 3253600
		}

		It "Solves 8 + 248 + 369" {
			$numbers = @(8,248,369)
			$operator = "+"
			$result = SolveColumnProblem -Numbers $numbers -Operator $operator
			$result | Should -Be 625
		}

		It "Solves 356 * 24 * 1" {
			$numbers = @(356,24,1)
			$operator = "*"
			$result = SolveColumnProblem -Numbers $numbers -Operator $operator
			$result | Should -Be 8544
		}
	}
}

Describe "SolveProblem2" {
	BeforeAll {
		$source = ".\Problem 2.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem2 -InputPath $inputPath

		$result | Should -BeExactly 3263827
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
