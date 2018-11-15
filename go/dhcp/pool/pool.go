package pool

import (
	"errors"
	"math/rand"
	"net"
	"sync"
)

type DHCPPool struct {
	lock     *sync.Mutex
	free     map[uint64]bool
	mac      map[uint64]net.HardwareAddr
	capacity uint64
}

func NewDHCPPool(capacity uint64) *DHCPPool {
	d := &DHCPPool{
		lock:     &sync.Mutex{},
		free:     make(map[uint64]bool),
		mac:      make(map[uint64]net.HardwareAddr),
		capacity: capacity,
	}
	for i := uint64(0); i < d.capacity; i++ {
		d.free[i] = true
	}
	return d
}

// Reserves an IP in the pool, returns an error if the IP has already been reserved
func (dp *DHCPPool) ReserveIPIndex(index uint64, mac net.HardwareAddr) (error, net.HardwareAddr) {
	dp.lock.Lock()
	defer dp.lock.Unlock()

	emptyMac, _ := net.ParseMAC("00:00:00:00:00:00")
	if index >= dp.capacity {
		return errors.New("Trying to reserve an IP that is outside the capacity of this pool"), emptyMac
	}

	if _, free := dp.free[index]; free {
		delete(dp.free, index)
		dp.mac[index] = mac
		return nil, mac
	} else {
		return errors.New("IP is already reserved"), emptyMac
	}
}

// Frees an IP in the pool, returns an error if the IP is already free
func (dp *DHCPPool) FreeIPIndex(index uint64) error {
	dp.lock.Lock()
	defer dp.lock.Unlock()

	if !dp.IndexInPool(index) {
		return errors.New("Trying to free an IP that is outside the capacity of this pool")
	}

	if _, free := dp.free[index]; free {
		return errors.New("IP is already free")
	} else {
		dp.free[index] = true
		delete(dp.mac, index)
		return nil
	}
}

// Check if the IP is free at the index
func (dp *DHCPPool) IsFreeIPAtIndex(index uint64) bool {
	dp.lock.Lock()
	defer dp.lock.Unlock()

	if !dp.IndexInPool(index) {
		return false
	}

	if _, free := dp.free[index]; free {
		return true
	} else {
		return false
	}
}

// Returns a random free IP address, an error if the pool is full
func (dp *DHCPPool) GetFreeIPIndex(mac net.HardwareAddr) (uint64, net.HardwareAddr, error) {
	dp.lock.Lock()
	defer dp.lock.Unlock()

	emptyMac, _ := net.ParseMAC("00:00:00:00:00:00")

	if len(dp.free) == 0 {
		return 0, emptyMac, errors.New("DHCP pool is full")
	}
	index := rand.Intn(len(dp.free))

	var available uint64
	for available = range dp.free {
		if index == 0 {
			break
		}
		index--
	}

	delete(dp.free, available)
	dp.mac[available] = mac

	return available, mac, nil
}

// Returns whether or not a specific index is in the capacity of the pool
func (dp *DHCPPool) IndexInPool(index uint64) bool {
	return index < dp.capacity
}

// Returns the amount of free IPs in the pool
func (dp *DHCPPool) FreeIPsRemaining() uint64 {
	dp.lock.Lock()
	defer dp.lock.Unlock()
	return uint64(len(dp.free))
}

// Returns the capacity of the pool
func (dp *DHCPPool) Capacity() uint64 {
	return dp.capacity
}
