package exec

import (
	"bytes"
	"os/exec"
)

type Commander interface {
	Run(name string, args ...string) (string error)
}

type Command struct{}

func (c Command) Run(name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		return stderr.String(), err
	}
	return stdout.String(), nil
}

func NewCommand() Command {
	return Command{}
}
