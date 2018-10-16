/*
 * Copyright (C) 2018, The Linux Foundation. All rights reserved.
 * Not a Contribution.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted (subject to the limitations in the
 * disclaimer below) provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *
 * * Neither the name of The Linux Foundation nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE
 * GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
 * HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*
 * Copyright 2008, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.bluetooth;

import android.bluetooth.IBluetoothCallback;
import android.bluetooth.IBluetoothMetadataListener;
import android.bluetooth.IBluetoothSocketManager;
import android.bluetooth.IBluetoothStateChangeCallback;
import android.bluetooth.BluetoothActivityEnergyInfo;
import android.bluetooth.BluetoothClass;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.OobData;
import android.os.ParcelUuid;
import android.os.ParcelFileDescriptor;
import android.os.ResultReceiver;

/**
 * System private API for talking with the Bluetooth service.
 *
 * {@hide}
 */
interface IBluetooth
{
    boolean isEnabled();
    int getState();
    boolean enable();
    boolean enableNoAutoConnect();
    boolean disable();

    String getAddress();
    ParcelUuid[] getUuids();
    boolean setName(in String name);
    String getName();
    BluetoothClass getBluetoothClass();
    boolean setBluetoothClass(in BluetoothClass bluetoothClass);

    int getIoCapability();
    boolean setIoCapability(int capability);
    int getLeIoCapability();
    boolean setLeIoCapability(int capability);

    int getScanMode();
    boolean setScanMode(int mode, int duration);

    int getDiscoverableTimeout();
    boolean setDiscoverableTimeout(int timeout);

    boolean startDiscovery(String callingPackage);
    boolean cancelDiscovery();
    boolean isDiscovering();
    long getDiscoveryEndMillis();

    int getAdapterConnectionState();
    int getProfileConnectionState(int profile);

    BluetoothDevice[] getBondedDevices();
    boolean createBond(in BluetoothDevice device, in int transport);
    boolean createBondOutOfBand(in BluetoothDevice device, in int transport, in OobData oobData);
    boolean cancelBondProcess(in BluetoothDevice device);
    boolean removeBond(in BluetoothDevice device);
    int getBondState(in BluetoothDevice device);
    boolean isBondingInitiatedLocally(in BluetoothDevice device);
    long getSupportedProfiles();
    int getConnectionState(in BluetoothDevice device);

    String getRemoteName(in BluetoothDevice device);
    int getRemoteType(in BluetoothDevice device);
    String getRemoteAlias(in BluetoothDevice device);
    boolean setRemoteAlias(in BluetoothDevice device, in String name);
    int getRemoteClass(in BluetoothDevice device);
    ParcelUuid[] getRemoteUuids(in BluetoothDevice device);
    boolean fetchRemoteUuids(in BluetoothDevice device);
    boolean sdpSearch(in BluetoothDevice device, in ParcelUuid uuid);
    int getBatteryLevel(in BluetoothDevice device);
    int getMaxConnectedAudioDevices();

    boolean isTwsPlusDevice(in BluetoothDevice device);
    String getTwsPlusPeerAddress(in BluetoothDevice device);
    boolean setPin(in BluetoothDevice device, boolean accept, int len, in byte[] pinCode);
    boolean setPasskey(in BluetoothDevice device, boolean accept, int len, in byte[]
    passkey);
    boolean setPairingConfirmation(in BluetoothDevice device, boolean accept);

    int getPhonebookAccessPermission(in BluetoothDevice device);
    boolean setSilenceMode(in BluetoothDevice device, boolean silence);
    boolean getSilenceMode(in BluetoothDevice device);
    boolean setPhonebookAccessPermission(in BluetoothDevice device, int value);
    int getMessageAccessPermission(in BluetoothDevice device);
    boolean setMessageAccessPermission(in BluetoothDevice device, int value);
    int getSimAccessPermission(in BluetoothDevice device);
    boolean setSimAccessPermission(in BluetoothDevice device, int value);

    void sendConnectionStateChange(in BluetoothDevice device, int profile, int state, int prevState);

    void registerCallback(in IBluetoothCallback callback);
    void unregisterCallback(in IBluetoothCallback callback);

    // For Socket
    IBluetoothSocketManager getSocketManager();

    boolean factoryReset();

    boolean isMultiAdvertisementSupported();
    boolean isOffloadedFilteringSupported();
    boolean isOffloadedScanBatchingSupported();
    boolean isActivityAndEnergyReportingSupported();
    boolean isLe2MPhySupported();
    boolean isLeCodedPhySupported();
    boolean isLeExtendedAdvertisingSupported();
    boolean isLePeriodicAdvertisingSupported();
    int getLeMaximumAdvertisingDataLength();
    BluetoothActivityEnergyInfo reportActivityInfo();

    // For Metadata
    boolean registerMetadataListener(in IBluetoothMetadataListener listener, in BluetoothDevice device);
    boolean unregisterMetadataListener(in BluetoothDevice device);
    boolean setMetadata(in BluetoothDevice device, in int key, in byte[] value);
    byte[] getMetadata(in BluetoothDevice device, in int key);


    /**
     * Requests the controller activity info asynchronously.
     * The implementor is expected to reply with the
     * {@link android.bluetooth.BluetoothActivityEnergyInfo} object placed into the Bundle with the
     * key {@link android.os.BatteryStats#RESULT_RECEIVER_CONTROLLER_KEY}.
     * The result code is ignored.
     */
    oneway void requestActivityInfo(in ResultReceiver result);

    void onLeServiceUp();
    void updateQuietModeStatus(boolean quietMode);
    void onBrEdrDown();
}
