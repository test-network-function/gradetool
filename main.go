package main

import (
	"fmt"
	"log"
	"os"

	"github.com/spf13/cobra"
	"github.com/test-network-function/gradetool/tool"
)

var (
	results    string
	policy     string
	OutputPath string

	cResult = &cobra.Command{
		Use:   "claimscore",
		Short: "claimscore",
		RunE:  runClaimScore,
	}
)

func main() {
	if err := cResult.Execute(); err != nil {
		log.Fatal(err)
	}
}

func runClaimScore(cmd *cobra.Command, args []string) error {
	resultsPath := results
	policyPath := policy
	outputPath := OutputPath

	err := tool.GenerateGrade(resultsPath, policyPath, outputPath)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return nil
}

func NewCommand() *cobra.Command {
	cResult.Flags().StringVarP(
		&results, "results", "r", "",
		"Path to the input claim.json file",
	)
	cResult.Flags().StringVarP(
		&policy, "policy", "p", "",
		"Path to the input policy file",
	)
	cResult.Flags().StringVarP(
		&OutputPath, "OutputPath", "o", "",
		"Path to the output file",
	)
	err := cResult.MarkFlagRequired("results")
	if err != nil {
		return nil
	}
	err = cResult.MarkFlagRequired("policy")
	if err != nil {
		return nil
	}
	err = cResult.MarkFlagRequired("OutputPath")
	if err != nil {
		return nil
	}
	return cResult
}
