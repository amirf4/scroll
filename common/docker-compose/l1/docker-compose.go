package dockercompose

import (
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
	"os"
	"path/filepath"
	"time"

	"github.com/cloudflare/cfssl/log"
	"github.com/scroll-tech/go-ethereum/ethclient"
	tc "github.com/testcontainers/testcontainers-go/modules/compose"
	"github.com/testcontainers/testcontainers-go/wait"
)

// PoSL1TestEnv represents the config needed to test in PoS Layer 1.
type PoSL1TestEnv struct {
	workDir        string
	compose        tc.ComposeStack
	gethHTTPPort   int
	hostPath       string
	dataPathRandom string
}

// NewPoSL1TestEnv creates and initializes a new instance of PoSL1TestEnv with a random HTTP port.
func NewPoSL1TestEnv() (*PoSL1TestEnv, error) {
	rootDir, err := findProjectRootDir()
	if err != nil {
		return nil, fmt.Errorf("failed to find project root directory: %v", err)
	}

	hostPath, found := os.LookupEnv("HOST_PATH")
	if !found {
		hostPath = ""
	}

	rnd, err := rand.Int(rand.Reader, big.NewInt(65536-1024))
	if err != nil {
		return nil, fmt.Errorf("failed to generate a random: %v", err)
	}
	gethHTTPPort := int(rnd.Int64()) + 1024

	if err := os.Setenv("GETH_HTTP_PORT", fmt.Sprintf("%d", gethHTTPPort)); err != nil {
		return nil, fmt.Errorf("failed to set GETH_HTTP_PORT: %v", err)
	}

	return &PoSL1TestEnv{
		workDir:        filepath.Join(rootDir, "common", "docker-compose", "l1"),
		gethHTTPPort:   gethHTTPPort,
		hostPath:       hostPath,
		dataPathRandom: fmt.Sprintf("data_%d", time.Now().UnixNano()),
	}, nil
}

// Start starts the PoS L1 test environment by running the associated Docker Compose configuration.
func (e *PoSL1TestEnv) Start() error {
	var err error
	e.compose, err = tc.NewDockerCompose([]string{filepath.Join(e.workDir, "docker-compose.yml")}...)
	if err != nil {
		return fmt.Errorf("failed to create docker compose: %w", err)
	}

	env := map[string]string{
		"GETH_HTTP_PORT":   fmt.Sprintf("%d", e.gethHTTPPort),
		"DATA_PATH_RANDOM": e.dataPathRandom,
	}

	if e.hostPath != "" {
		env["HOST_PATH"] = e.hostPath
	}

	if err = e.compose.WaitForService("geth", wait.NewHTTPStrategy("/").WithPort("8545/tcp").WithStartupTimeout(15*time.Second)).WithEnv(env).Up(context.Background()); err != nil {
		if errStop := e.Stop(); errStop != nil {
			log.Error("failed to stop PoS L1 test environment", "err", errStop)
		}
		return fmt.Errorf("failed to start PoS L1 test environment: %w", err)
	}

	return nil
}

// Stop stops the PoS L1 test environment by stopping and removing the associated Docker Compose services.
func (e *PoSL1TestEnv) Stop() error {
	if e.compose != nil {
		if err := e.compose.Down(context.Background(), tc.RemoveOrphans(true), tc.RemoveVolumes(true), tc.RemoveImagesLocal); err != nil {
			return fmt.Errorf("failed to stop PoS L1 test environment: %w", err)
		}
	}

	dirsToRemove := []string{
		filepath.Join(e.workDir, "consensus", e.dataPathRandom),
		filepath.Join(e.workDir, "execution", e.dataPathRandom),
	}

	for _, dir := range dirsToRemove {
		if err := os.RemoveAll(dir); err != nil {
			return fmt.Errorf("failed to remove data directory %s: %w", dir, err)
		}
	}
	return nil
}

// Endpoint returns the HTTP endpoint for the PoS L1 test environment.
func (e *PoSL1TestEnv) Endpoint() string {
	return fmt.Sprintf("http://127.0.0.1:%d", e.gethHTTPPort)
}

// L1Client returns an ethclient by dialing the running PoS L1 test environment
func (e *PoSL1TestEnv) L1Client() (*ethclient.Client, error) {
	if e == nil {
		return nil, fmt.Errorf("PoS L1 test environment is not initialized")
	}

	client, err := ethclient.Dial(e.Endpoint())
	if err != nil {
		return nil, fmt.Errorf("failed to dial PoS L1 test environment: %w", err)
	}
	return client, nil
}

func findProjectRootDir() (string, error) {
	currentDir, err := os.Getwd()
	if err != nil {
		return "", fmt.Errorf("failed to get working directory: %w", err)
	}

	for {
		_, err := os.Stat(filepath.Join(currentDir, "go.work"))
		if err == nil {
			return currentDir, nil
		}

		parentDir := filepath.Dir(currentDir)
		if parentDir == currentDir {
			return "", fmt.Errorf("go.work file not found in any parent directory")
		}

		currentDir = parentDir
	}
}