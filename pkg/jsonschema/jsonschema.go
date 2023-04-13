package jsonschema

import (
	"os"
	"strings"

	"github.com/xeipuuv/gojsonschema"
)

// ValidateJSONFileAgainstSchema validates a given file against the supplied JSON schema.
func ValidateJSONFileAgainstSchema(filename, schemaPath string) (*gojsonschema.Result, error) {
	inputBytes, err := os.ReadFile(strings.TrimSpace(filename))
	if err != nil {
		return nil, err
	}
	return ValidateJSONAgainstSchema(inputBytes, strings.TrimSpace(schemaPath))
}

// ValidateJSONAgainstSchema validates a given byte array against the supplied JSON schema.
func ValidateJSONAgainstSchema(inputBytes []byte, schemaPath string) (*gojsonschema.Result, error) {
	schemaBytes, err := os.ReadFile(schemaPath)
	if err != nil {
		return nil, err
	}

	schemaLoader := gojsonschema.NewStringLoader(string(schemaBytes))
	if err != nil {
		return nil, err
	}

	inputLoader := gojsonschema.NewStringLoader(string(inputBytes))
	schema, err := gojsonschema.NewSchema(schemaLoader)
	if err != nil {
		return nil, err
	}
	return schema.Validate(inputLoader)
}
