package orm

import (
	"context"
	"fmt"
	"time"

	"github.com/scroll-tech/go-ethereum/common"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

// TokenType represents the type of token.
type TokenType int

// Constants for TokenType.
const (
	TokenTypeUnknown TokenType = iota
	TokenTypeETH
	TokenTypeERC20
	TokenTypeERC721
	TokenTypeERC1155
)

// MessageType represents the type of message.
type MessageType int

// Constants for MessageType.
const (
	MessageTypeUnknown MessageType = iota
	MessageTypeL1SentMessage
	MessageTypeL2SentMessage
)

// TxStatusType represents the status of a transaction.
type TxStatusType int

// Constants for TxStatusType.
const (
	TxStatusTypeUnknown TxStatusType = iota
	TxStatusTypeSent
	TxStatusTypeSentFailed
	TxStatusTypeRelayed
	TxStatusTypeRelayedFailed
	TxStatusTypeSkipped
	TxStatusTypeDropped
)

// RollupStatusType represents the status of a rollup.
type RollupStatusType int

// Constants for RollupStatusType.
const (
	RollupStatusTypeUnknown   RollupStatusType = iota
	RollupStatusTypeFinalized                  // only batch finalized status is used.
)

// MessageQueueEventType represents the type of message queue event.
type MessageQueueEventType int

// Constants for MessageQueueEventType.
const (
	MessageQueueEventTypeUnknown MessageQueueEventType = iota
	MessageQueueEventTypeQueueTransaction
	MessageQueueEventTypeDequeueTransaction
	MessageQueueEventTypeDropTransaction
)

// MessageQueueEvent struct represents the details of a batch event.
type MessageQueueEvent struct {
	EventType   MessageQueueEventType
	MessageHash common.Hash
	QueueIndex  uint64
	TxHash      common.Hash
}

// CrossMessage represents a cross message.
type CrossMessage struct {
	db *gorm.DB `gorm:"column:-"`

	ID             uint64     `json:"id" gorm:"column:id;primary_key"`
	MessageType    int        `json:"message_type" gorm:"column:message_type"`
	QueueIndex     uint64     `json:"queue_index" gorm:"column:queue_index"`
	RollupStatus   int        `json:"rollup_status" gorm:"column:rollup_status"`
	TxStatus       int        `json:"tx_status" gorm:"column:tx_status"`
	TokenType      int        `json:"token_type" gorm:"column:token_type"`
	Sender         string     `json:"sender" gorm:"column:sender"`
	Receiver       string     `json:"receiver" gorm:"column:receiver"`
	MessageHash    string     `json:"message_hash" gorm:"column:message_hash"`
	L1TxHash       string     `json:"l1_tx_hash" gorm:"column:l1_tx_hash"`
	L2TxHash       string     `json:"l2_tx_hash" gorm:"column:l2_tx_hash"`
	L1BlockNumber  uint64     `json:"l1_block_number" gorm:"column:l1_block_number"`
	L2BlockNumber  uint64     `json:"l2_block_number" gorm:"column:l2_block_number"`
	L1TokenAddress string     `json:"l1_token_address" gorm:"column:l1_token_address"`
	L2TokenAddress string     `json:"l2_token_address" gorm:"column:l2_token_address"`
	TokenIDs       string     `json:"token_ids" gorm:"column:token_ids"`
	TokenAmounts   string     `json:"token_amounts" gorm:"column:token_amounts"`
	BlockTimestamp uint64     `json:"block_timestamp" gorm:"column:block_timestamp"`
	MessageFrom    string     `json:"message_from" gorm:"column:message_from"`
	MessageTo      string     `json:"message_to" gorm:"column:message_to"`
	MessageValue   string     `json:"message_value" gorm:"column:message_value"`
	MessageNonce   uint64     `json:"message_nonce" gorm:"column:message_nonce"`
	MessageData    string     `json:"message_data" gorm:"column:message_data"`
	MerkleProof    []byte     `json:"merkle_proof" gorm:"column:merkle_proof"`
	BatchIndex     uint64     `json:"batch_index" gorm:"column:batch_index"`
	CreatedAt      time.Time  `json:"created_at" gorm:"column:created_at"`
	UpdatedAt      time.Time  `json:"updated_at" gorm:"column:updated_at"`
	DeletedAt      *time.Time `json:"deleted_at" gorm:"column:deleted_at"`
}

// TableName returns the table name for the CrossMessage model.
func (*CrossMessage) TableName() string {
	return "cross_message"
}

// NewCrossMessage returns a new instance of CrossMessage.
func NewCrossMessage(db *gorm.DB) *CrossMessage {
	return &CrossMessage{db: db}
}

// GetMessageProcessedHeightInDB returns the latest processed cross message height from the database for a given message type.
func (c *CrossMessage) GetMessageProcessedHeightInDB(ctx context.Context, messageType MessageType) (uint64, error) {
	var message CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("message_type = ?", messageType)
	switch {
	case messageType == MessageTypeL1SentMessage:
		db = db.Order("l1_block_number desc")
	case messageType == MessageTypeL2SentMessage:
		db = db.Order("l2_block_number desc")
	}
	if err := db.First(&message).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return 0, nil
		}
		return 0, fmt.Errorf("failed to get latest processed height, type: %v, error: %w", messageType, err)
	}
	switch {
	case messageType == MessageTypeL1SentMessage:
		return message.L1BlockNumber, nil
	case messageType == MessageTypeL2SentMessage:
		return message.L2BlockNumber, nil
	default:
		return 0, fmt.Errorf("invalid message type: %v", messageType)
	}
}

// GetLatestL2Withdrawal returns the latest processed L2 withdrawal from the database.
func (c *CrossMessage) GetLatestL2Withdrawal(ctx context.Context) (*CrossMessage, error) {
	var message CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("message_type = ?", MessageTypeL2SentMessage)
	db = db.Where("tx_status != ?", TxStatusTypeSentFailed)
	db = db.Order("message_nonce desc")
	if err := db.First(&message).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to get latest L2 sent message event, error: %w", err)
	}
	return &message, nil
}

// GetLatestFinalizedL2WithdrawalBlockHeight returns the latest finalized L2 sent message block height from the database.
func (c *CrossMessage) GetLatestFinalizedL2WithdrawalBlockHeight(ctx context.Context) (uint64, error) {
	var message CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("message_type = ?", MessageTypeL2SentMessage)
	db = db.Where("rollup_status", RollupStatusTypeFinalized)
	db = db.Where("tx_status != ?", TxStatusTypeSentFailed)
	db = db.Order("message_nonce desc")
	if err := db.First(&message).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return 0, nil
		}
		return 0, fmt.Errorf("failed to get latest L2 sent message event, error: %w", err)
	}
	return message.L2BlockNumber, nil
}

// GetMessagesByTxHashes retrieves all cross messages from the database that match the provided transaction hashes.
func (c *CrossMessage) GetMessagesByTxHashes(ctx context.Context, txHashes []string) ([]*CrossMessage, error) {
	var messages []*CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("l1_tx_hash IN (?) OR l2_tx_hash IN (?)", txHashes, txHashes)
	if err := db.Find(&messages).Error; err != nil {
		return nil, fmt.Errorf("failed to get L2 messages by tx hashes, tx hashes: %v, error: %w", txHashes, err)
	}
	return messages, nil
}

// GetL2ClaimableWithdrawalsByAddress retrieves all L2 claimable withdrawal messages for a given sender address.
func (c *CrossMessage) GetL2ClaimableWithdrawalsByAddress(ctx context.Context, sender string) ([]*CrossMessage, error) {
	var messages []*CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("message_type = ?", MessageTypeL2SentMessage)
	db = db.Where("tx_status = ?", TxStatusTypeSent)
	db = db.Where("rollup_status = ?", RollupStatusTypeFinalized)
	db = db.Where("sender = ?", sender)
	db = db.Order("block_timestamp DESC")
	db = db.Limit(500)
	if err := db.Find(&messages).Error; err != nil {
		return nil, fmt.Errorf("failed to get L2 claimable withdrawal messages by sender address, sender: %v, error: %w", sender, err)
	}
	return messages, nil
}

// GetL2WithdrawalsByAddress retrieves all L2 claimable withdrawal messages for a given sender address.
func (c *CrossMessage) GetL2WithdrawalsByAddress(ctx context.Context, sender string) ([]*CrossMessage, error) {
	var messages []*CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("message_type = ?", MessageTypeL2SentMessage)
	db = db.Where("sender = ?", sender)
	db = db.Order("block_timestamp DESC")
	db = db.Limit(500)
	if err := db.Find(&messages).Error; err != nil {
		return nil, fmt.Errorf("failed to get L2 withdrawal messages by sender address, sender: %v, error: %w", sender, err)
	}
	return messages, nil
}

// GetTxsByAddress retrieves all txs for a given sender address.
func (c *CrossMessage) GetTxsByAddress(ctx context.Context, sender string) ([]*CrossMessage, error) {
	var messages []*CrossMessage
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("sender = ?", sender)
	db = db.Order("block_timestamp DESC")
	db = db.Limit(500)
	if err := db.Find(&messages).Error; err != nil {
		return nil, fmt.Errorf("failed to get all txs by sender address, sender: %v, error: %w", sender, err)
	}
	return messages, nil
}

// UpdateL1MessageQueueEventsInfo updates the information about L1 message queue events in the database.
func (c *CrossMessage) UpdateL1MessageQueueEventsInfo(ctx context.Context, l1MessageQueueEvents []*MessageQueueEvent, dbTX ...*gorm.DB) error {
	originalDB := c.db
	if len(dbTX) > 0 && dbTX[0] != nil {
		originalDB = dbTX[0]
	}
	originalDB = originalDB.WithContext(ctx)
	originalDB = originalDB.Model(&CrossMessage{})
	for _, l1MessageQueueEvent := range l1MessageQueueEvents {
		db := originalDB
		if l1MessageQueueEvent.EventType == MessageQueueEventTypeQueueTransaction {
			updateFields := make(map[string]interface{})
			// Update tx hash if it's a message replay.
			updateFields["l1_tx_hash"] = l1MessageQueueEvent.TxHash.String()
			updateFields["queue_index"] = l1MessageQueueEvent.QueueIndex
			db = db.Where("message_hash = ?", l1MessageQueueEvent.MessageHash.String())
			if err := db.Updates(updateFields).Error; err != nil {
				return fmt.Errorf("failed to update L1 tx hash of QueueTransaction, event: %+v, error: %w", l1MessageQueueEvent, err)
			}
		}
		if l1MessageQueueEvent.EventType == MessageQueueEventTypeDequeueTransaction {
			updateFields := make(map[string]interface{})
			updateFields["tx_status"] = TxStatusTypeSkipped
			db = db.Where("queue_index = ?", l1MessageQueueEvent.QueueIndex)
			if err := db.Updates(updateFields).Error; err != nil {
				return fmt.Errorf("failed to update message status as skipped, event: %+v, error: %w", l1MessageQueueEvent, err)
			}
		}
		if l1MessageQueueEvent.EventType == MessageQueueEventTypeDropTransaction {
			updateFields := make(map[string]interface{})
			updateFields["tx_status"] = TxStatusTypeDropped
			db = db.Where("queue_index = ?", l1MessageQueueEvent.QueueIndex)
			if err := db.Updates(updateFields).Error; err != nil {
				return fmt.Errorf("failed to update message status as dropped, event: %+v, error: %w", l1MessageQueueEvent, err)
			}
		}
	}
	return nil
}

// UpdateBatchStatusOfL2Withdrawals updates batch status of L2 withdrawals.
func (c *CrossMessage) UpdateBatchStatusOfL2Withdrawals(ctx context.Context, startBlockNumber, endBlockNumber, batchIndex uint64) error {
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Where("message_type = ?", MessageTypeL2SentMessage)
	db = db.Where("l1_block_number >= ?", startBlockNumber)
	db = db.Where("l1_block_number <= ?", endBlockNumber)
	updateFields := make(map[string]interface{})
	updateFields["batch_index"] = batchIndex
	updateFields["rollup_status"] = RollupStatusTypeFinalized
	if err := db.Updates(updateFields).Error; err != nil {
		return fmt.Errorf("failed to update batch status of L2 sent messages, start: %v, end: %v, index: %v, error: %w", startBlockNumber, endBlockNumber, batchIndex, err)
	}
	return nil
}

// InsertOrUpdateL1Messages inserts or updates a list of L1 cross messages into the database.
func (c *CrossMessage) InsertOrUpdateL1Messages(ctx context.Context, messages []*CrossMessage, dbTX ...*gorm.DB) error {
	db := c.db
	if len(dbTX) > 0 && dbTX[0] != nil {
		db = dbTX[0]
	}
	db = db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "message_hash"}},
		DoUpdates: clause.AssignmentColumns([]string{"sender", "receiver", "token_type", "l1_block_number", "l1_tx_hash", "l1_token_address", "l2_token_address", "token_ids", "token_amounts", "message_type", "tx_status", "block_timestamp"}),
	})
	for _, message := range messages {
		if err := db.Create(message).Error; err != nil {
			return fmt.Errorf("failed to insert message, message: %+v, error: %w", message, err)
		}
	}
	return nil
}

// InsertOrUpdateL2Messages inserts or updates a list of L2 cross messages into the database.
func (c *CrossMessage) InsertOrUpdateL2Messages(ctx context.Context, messages []*CrossMessage, dbTX ...*gorm.DB) error {
	db := c.db
	if len(dbTX) > 0 && dbTX[0] != nil {
		db = dbTX[0]
	}
	db = db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "message_hash"}},
		DoUpdates: clause.AssignmentColumns([]string{"sender", "receiver", "token_type", "l2_block_number", "l2_tx_hash", "l1_token_address", "l2_token_address", "token_ids", "token_amounts", "message_type", "tx_status", "block_timestamp"}),
	})
	for _, message := range messages {
		if err := db.Create(message).Error; err != nil {
			return fmt.Errorf("failed to insert message, message: %+v, error: %w", message, err)
		}
	}
	return nil
}

// InsertFailedMessages inserts a list of failed L1 or L2 cross messages into the database.
// Failed messages are fetched only once, so they're just inserted without checking for duplicates.
func (c *CrossMessage) InsertFailedMessages(ctx context.Context, messages []*CrossMessage, dbTX ...*gorm.DB) error {
	db := c.db
	if len(dbTX) > 0 && dbTX[0] != nil {
		db = dbTX[0]
	}

	db = db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	for _, message := range messages {
		if err := db.Create(message).Error; err != nil {
			return fmt.Errorf("failed to insert message, message: %+v, error: %w", message, err)
		}
	}
	return nil
}

// InsertOrUpdateL2RelayedMessagesOfL1Deposits inserts or updates the database with a list of L2 relayed messages related to L1 deposits.
func (c *CrossMessage) InsertOrUpdateL2RelayedMessagesOfL1Deposits(ctx context.Context, l2RelayedMessages []*CrossMessage, dbTX ...*gorm.DB) error {
	db := c.db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "message_hash"}},
		DoUpdates: clause.AssignmentColumns([]string{"l2_block_number", "l2_tx_hash", "tx_status"}),
	})
	for _, l2RelayedMessage := range l2RelayedMessages {
		result := db.Create(l2RelayedMessage)
		if result.Error != nil {
			return fmt.Errorf("failed to update L2 relayed message of L1 deposit, L2 relayed message: %+v, error: %w", l2RelayedMessage, result.Error)
		}
	}
	return nil
}

// InsertOrUpdateL1RelayedMessagesOfL2Withdrawals inserts or updates the database with a list of L1 relayed messages related to L2 withdrawals.
func (c *CrossMessage) InsertOrUpdateL1RelayedMessagesOfL2Withdrawals(ctx context.Context, l1RelayedMessages []*CrossMessage, dbTX ...*gorm.DB) error {
	db := c.db
	if len(dbTX) > 0 && dbTX[0] != nil {
		db = dbTX[0]
	}
	db = db.WithContext(ctx)
	db = db.Model(&CrossMessage{})
	db = db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "message_hash"}},
		DoUpdates: clause.AssignmentColumns([]string{"l1_block_number", "l1_tx_hash", "tx_status"}),
	})
	for _, l1RelayedMessage := range l1RelayedMessages {
		result := db.Create(l1RelayedMessage)
		if result.Error != nil {
			return fmt.Errorf("failed to update L1 relayed message of L2 withdrawal, L1 relayed message: %+v, error: %w", l1RelayedMessage, result.Error)
		}
	}
	return nil
}
