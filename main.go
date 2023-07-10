package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/spf13/cobra"
	"github.com/test-network-function/gradetool/tool"
)

var (
	results    string
	policy     string
	OutputPath string

	grade = &cobra.Command{
		Use:   "gradetool",
		Short: "gradetool",
		RunE:  runGradetool,
	}
)

func main() {
	// Build command
	NewCommand()
	if err := grade.Execute(); err != nil {
		log.Fatal(err)
	}
}

func runGradetool(_ *cobra.Command, _ []string) error {
	resultsPath := results
	policyPath := policy
	outputPath := OutputPath

	// Trim the spaces out of these paths
	resultsPath = strings.TrimSpace(resultsPath)
	policyPath = strings.TrimSpace(policyPath)
	outputPath = strings.TrimSpace(outputPath)

	// Generate the grade
	err := tool.GenerateGrade(resultsPath, policyPath, outputPath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// read the output file and display to user
	outFile, err := os.ReadFile(outputPath)
	if err != nil {
		fmt.Println(err)
		return err
	}
	outFileString := string(outFile)
	fmt.Println(outFileString)
	return nil
}

func NewCommand() *cobra.Command {
	grade.Flags().StringVarP(&results, "results", "r", "", "Path to the input test results file")
	grade.Flags().StringVarP(&policy, "policy", "p", "", "Path to the input policy file")
	grade.Flags().StringVarP(&OutputPath, "OutputPath", "o", "", "Path to the output file")

	// Mark required flags
	err := grade.MarkFlagRequired("results")
	if err != nil {
		return nil
	}
	err = grade.MarkFlagRequired("policy")
	if err != nil {
		return nil
	}
	err = grade.MarkFlagRequired("OutputPath")
	if err != nil {
		return nil
	}
	return grade
}
