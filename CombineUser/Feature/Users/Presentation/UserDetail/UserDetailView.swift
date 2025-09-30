//
//  UserDetailView.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/30.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            
            headerSection
            
            contactSection
            
            addressSection
            
            companySection
 
        }
        .listStyle(.plain)

    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 100, height: 100)
                .overlay {
                    Text(user.name.prefix(1))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            
            VStack(spacing: 8) {
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("@\(user.username)")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Contact Information", icon: "person.fill")
            
            InfoRowView(
                icon: "envelope.fill",
                title: "Email",
                value: user.email,
                color: .red
            )
            
            InfoRowView(
                icon: "phone.fill",
                title: "Phone",
                value: user.phone,
                color: .green
            )
            
            InfoRowView(
                icon: "globe",
                title: "Website",
                value: user.website,
                color: .blue
            )
        }
    }
    
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Address", icon: "location.fill")
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(user.address.street), \(user.address.suite)")
                    .font(.body)
                
                Text("\(user.address.city), \(user.address.zipcode)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var companySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(title: "Company", icon: "building.2.fill")
            
            VStack(alignment: .leading, spacing: 12) {
                Text(user.company.name)
                    .font(.headline)
                
                Text(user.company.catchPhrase)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
                
                Text(user.company.bs)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Supporting Views

struct SectionHeaderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

struct InfoRowView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    let sampleUser = User(
        id: 1,
        name: "John Doe",
        username: "johndoe",
        email: "john@example.com",
        phone: "1-234-567-8900",
        website: "john.org",
        address: Address(
            street: "123 Main St",
            suite: "Apt. 4",
            city: "Anytown",
            zipcode: "12345"
        ),
        company: Company(
            name: "ACME Corp",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )
    
    return UserDetailView(user: sampleUser)
}
